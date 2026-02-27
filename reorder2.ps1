$html = Get-Content 'index.html' -Raw
$pattern = '(?sm)<div class="product-grid">(.*?)    </section>'
if ($html -match $pattern) {
    $gridHtml = $matches[1]
    
    # Split the gridHtml by the product card start div
    $cards = $gridHtml -split '<div class="product-card">' | Where-Object { $_.Trim() -ne '' }
    
    $chillies = @()
    $tomatoes = @()
    $okra = @()
    $bitterGourds = @()
    $others = @()
    
    $seenTitles = @{}

    foreach ($cardSplit in $cards) {
        $card = '<div class="product-card">' + $cardSplit
        
        $title = ''
        if ($card -match '<h3>(.*?)<\/h3>') {
            $title = $matches[1].Trim().ToUpper()
        }
        
        if ($title -eq '') {
            $others += $card
            continue
        }
        
        if ($seenTitles.ContainsKey($title)) {
            Write-Host "Skipping duplicate: $title"
            continue
        }
        $seenTitles[$title] = $true

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

    # Join the arrays in the exact sequence requested
    # 1. Mirche
    # 2. Tamatar
    # 3. Okra
    # 4. Bitter Gourd
    # 5. Others
    
    $allCardsJoined = ($chillies + $tomatoes + $okra + $bitterGourds + $others) -join "`n"
    
    $newGridHtml = "<div class=""product-grid"">`n$allCardsJoined`n    </div>`n    </section>"
    
    $newHtml = $html -replace $pattern, $newGridHtml
    Set-Content 'index.html' -Value $newHtml -Encoding UTF8
    
    Write-Host "Reordering complete. Unique products found: $($seenTitles.Count)"
}
else {
    Write-Host "Could not find the product grid."
}
