$html = Get-Content index.html -Raw
$gridStart = $html.IndexOf('<div class="product-grid">') + '<div class="product-grid">'.Length
$gridEndMatch = [regex]::Match($html.Substring($gridStart), '(?s)(</div>\s*</div>\s*</div>\s*</div>\s*</section>)')
if (-not $gridEndMatch.Success) {
    # If not found, try alternative
    $gridEndMatch = [regex]::Match($html.Substring($gridStart), '(?s)(</div>\s*</div>\s*</div>\s*</section>)')
}

$gridEnd = $gridStart + $gridEndMatch.Index
$gridContent = $html.Substring($gridStart, $gridEnd - $gridStart)

# Split by product card.
$parts = $gridContent -split '(?=<div class="product-card")'
$pictured = @()
$unpictured = @()

foreach ($part in $parts) {
    if ([string]::IsNullOrWhiteSpace($part)) { continue }
    if ($part -match '<div class="product-card"') {
        if ($part -match 'src="ergon logo\.png"' -or $part -match 'src="hybrid_cucumbers\.png"') {
            $unpictured += $part
        } else {
            $pictured += $part
        }
    } else {
        # any prefix whitespace
        $pictured += $part
    }
}

$newGridContent = ($pictured -join "") + ($unpictured -join "")
$newHtml = $html.Substring(0, $gridStart) + $newGridContent + $html.Substring($gridEnd)

$newHtml | Set-Content index.html
Write-Host "Pictured: $($pictured.Count), Unpictured: $($unpictured.Count)"
