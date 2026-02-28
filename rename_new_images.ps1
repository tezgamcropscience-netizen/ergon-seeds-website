# Rename script for newest product images
$renames = @{
    "Hybrid Tomatoes T-80 F-1.jpg"      = "tomato_t80_f1.jpg"
    "JOHNSON F-1.jpg"                   = "tomato_johnson_f1.jpg"
    "PEA CLASSIC.png"                   = "pea_classic_1.png"
    "PEA CLASSIC..png"                  = "pea_classic_2.png"
    "FRENCH BEAN OSAKA.png"             = "french_bean_osaka.png"
    "TINDA DIL PASAND.png"              = "tinda_dil_pasand_1.png"
    "TINDA DILL PASANDD.png"            = "tinda_dil_pasand_2.png"
    "YARA F-1 HYBRID TOMATO SEEDS.jfif" = "tomato_yara_f1.jfif"
}

foreach ($old in $renames.Keys) {
    if (Test-Path $old) {
        $new = $renames[$old]
        Write-Host "Renaming $old to $new"
        Rename-Item -Path $old -NewName $new -ErrorAction SilentlyContinue
    }
}
