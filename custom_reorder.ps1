$html = Get-Content 'index.html' -Raw
$pattern = '(?sm)<div class="product-grid">(.*?)    </section>'
if ($html -match $pattern) {
    $gridHtml = $matches[1]
    
    # Split the gridHtml by the product card start div
    $cards = $gridHtml -split '<div class="product-card">' | Where-Object { $_.Trim() -ne '' }
    
    $remainingCards = @()
    $tigerTomato = $null
    $umangOkra = $null
    $tigerGourd = $null
    $spinach = $null

    foreach ($cardSplit in $cards) {
        $card = '<div class="product-card">' + $cardSplit
        
        if ($card -match 'TIGER F-1' -and $card -match '(?i)Hybrid Tomato') {
            $tigerTomato = $card
        }
        elseif ($card -match 'OKRA UMANG F-1') {
            $umangOkra = $card
        }
        elseif ($card -match 'TIGER F-1 HYBRID' -and $card -match '(?i)Hybrid Bitter Gourd') {
            $tigerGourd = $card
        }
        elseif ($card -match 'SPINACH ALL GREEN') {
            $spinach = $card
        }
        else {
            $remainingCards += $card
        }
    }

    if (-not $tigerTomato) { Write-Host "Missing Tiger Tomato" }
    if (-not $umangOkra) { Write-Host "Missing Umang Okra" }
    if (-not $tigerGourd) { Write-Host "Missing Tiger Bitter Gourd" }
    if (-not $spinach) { Write-Host "Missing Spinach" }

    $newCards = @()
    
    # Line 1: 0 to 3 properties
    for ($i = 0; $i -lt 4; $i++) {
        if ($remainingCards.Count -gt 0) {
            $newCards += $remainingCards[0]
            $remainingCards = $remainingCards[1..($remainingCards.Count - 1)]
        }
    }

    # Line 2: target items plus 2 from remaining
    if ($tigerTomato) { $newCards += $tigerTomato }
    if ($umangOkra) { $newCards += $umangOkra }
    for ($i = 0; $i -lt 2; $i++) {
        if ($remainingCards.Count -gt 0) {
            $newCards += $remainingCards[0]
            $remainingCards = $remainingCards[1..($remainingCards.Count - 1)]
        }
    }

    # Line 3: target items plus 2 from remaining
    if ($tigerGourd) { $newCards += $tigerGourd }
    if ($spinach) { $newCards += $spinach }
    for ($i = 0; $i -lt 2; $i++) {
        if ($remainingCards.Count -gt 0) {
            $newCards += $remainingCards[0]
            $remainingCards = $remainingCards[1..($remainingCards.Count - 1)]
        }
    }
    
    # Rest
    if ($null -ne $remainingCards -and $remainingCards.Count -gt 0) {
        $newCards += $remainingCards
    }

    $allCardsJoined = $newCards -join "`n"
    
    $newGridHtml = "<div class=""product-grid"">`n$allCardsJoined`n    </div>`n    </section>"
    
    $newHtml = $html -replace $pattern, $newGridHtml
    Set-Content 'index.html' -Value $newHtml -Encoding UTF8
    
    Write-Host "Custom reordering complete."
}
else {
    Write-Host "Could not find the product grid."
}
