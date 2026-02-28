# Rename script for professional filenames
$renames = @{
    "ergon logo.png"                       = "logo.png"
    "CRISOM MELON.jpeg"                    = "crimson_melon.jpeg"
    "HYBRID CUALI FLOWE.jpeg"              = "cauliflower_cf60_alt.jpeg"
    "HYBRID CUALI FLOWER CF-60 F1.jpeg"    = "cauliflower_cf60.jpeg"
    "HYBRID CUALI FLOWER CF.jpeg"          = "cauliflower_cf.jpeg"
    "HYBRID HOR PEPPER JAWALA MUKHI .jpeg" = "hot_pepper_jawala_mukhi.jpeg"
    "HYBRID SQUASH .jpeg"                  = "hybrid_squash.jpeg"
    "MOTI.png"                             = "moti.png"
    "Purple-Top-White-Globe-Turnip-01.gif" = "turnip_purple_top.gif"
    "RED BEET.jpg"                         = "red_beet.jpg"
    "RED.png"                              = "red_beet.png"
    "RESHAM SQUASH F-1 .jpeg"              = "resham_squash_f1.jpeg"
    "ROYAL STAR F-1 HYBRID.webp"           = "royal_star_hybrid.webp"
    "SHINGHAI .jpeg"                       = "shinghai.jpeg"
    "SHINGHAI R-06.jpeg"                   = "shinghai_r06.jpeg"
    "SHINGHAI R06.jpeg"                    = "shinghai_r06_alt.jpeg"
    "SQUASH F-1.jpeg"                      = "squash_f1.jpeg"
    "SQUASH TINDI.jpeg"                    = "squash_tindi.jpeg"
    "TIGER F-1 HYBIRD BITTER GOURD .jpeg"  = "bitter_gourd_tiger.jpeg"
    "UMANG OKRA HYBIRD SEEDS F-1 .jpeg"    = "okra_umang_hybrid.jpeg"
    "UMANG OKRA SEEDS F-1 .jpeg"           = "okra_umang.jpeg"
    "profile .jpeg"                        = "profile.jpeg"
}

foreach ($old in $renames.Keys) {
    if (Test-Path $old) {
        $new = $renames[$old]
        Write-Host "Renaming $old to $new"
        Rename-Item -Path $old -NewName $new -ErrorAction SilentlyContinue
    }
}
