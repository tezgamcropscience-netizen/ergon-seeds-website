$content = Get-Content 'index.html' -Raw
$content = [System.Text.RegularExpressions.Regex]::Replace($content, 'https:\/\/images\.unsplash\.com\/[^"''\s>]+', 'ergon logo.png')
Set-Content -Path 'index.html' -Value $content
