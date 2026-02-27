$html = Get-Content 'index.html' -Raw
$pattern = '(?sm)<div class="product-grid">(.*?)    </section>'
if ($html -match $pattern) {
    $gridHtml = $matches[1]
    
    $cards = $gridHtml -split '<div class="product-card">' | Where-Object { $_.Trim() -ne '' }
    
    $withImage = @()
    $withoutImage = @()
    
    foreach ($cardSplit in $cards) {
        $card = '<div class="product-card">' + $cardSplit
        
        # Check if the image source is the placeholder logo
        if ($card -match 'src="ergon logo\.png"') {
            $withoutImage += $card
        }
        else {
            $withImage += $card
        }
    }

    Write-Host "Found $($withImage.Count) products with images, $($withoutImage.Count) without."

    # Now let's try to maintain the category order WITHIN the withImage group, just to be nice
    function SortByCategory($cardArray) {
        $chillies = @()
        $tomatoes = @()
        $okra = @()
        $bitterGourds = @()
        $others = @()

        foreach ($card in $cardArray) {
            $title = ''
            if ($card -match '<h3>(.*?)<\/h3>') {
                $title = $matches[1].Trim().ToUpper()
            }
            
            $isChilli = ($card -match '(?i)CHILLI|PEPPER|CAPSICUM|^SUPER STAR|^GOLDEN STAR|^JAWALA|^HOT KING|^GERMAN INHAIM|^SKY SUPER') -and ($title -notmatch 'SHAMLI STAR|BLACK DAIMOND')
            $isTomato = $card -match '(?i)TOMATO|^TIGER F-1$|^ASIAN STAR'
            $isOkra = $card -match '(?i)OKRA'
            $isBitterGourd = $card -match '(?i)BITTER GOURD|KARELA|^AJMAL'

            if ($isTomato) {
                $tomatoes += $card
            }
            elseif ($isBitterGourd) {
                $bitterGourds += $card
            }
            elseif ($isOkra) {
                $okra += $card
            }
            elseif ($isChilli) {
                $chillies += $card
            }
            else {
                $others += $card
            }
        }
        return ($chillies + $tomatoes + $okra + $bitterGourds + $others)
    }

    $sortedWithImage = SortByCategory -cardArray $withImage
    $sortedWithoutImage = @()
    foreach ($c in $withoutImage) { $sortedWithoutImage += $c }

    $allCardsJoined = ($sortedWithImage + $sortedWithoutImage) -join "`n"
    
    $newGridHtml = "<div class=""product-grid"">`n$allCardsJoined`n    </div>`n    </section>"
    
    $newHtml = $html -replace $pattern, $newGridHtml
    Set-Content 'index.html' -Value $newHtml -Encoding UTF8
    
    Write-Host "Image-based reordering complete."
}
else {
    Write-Host "Could not find the product grid."
}
