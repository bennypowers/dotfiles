function sttym
    set -lx AMD_HDR_ENABLE 1
    set -lx ENABLE_GAMESCOPE_WSI 1
    set -lx DXVK_HDR 1
    set -lx STEAM_DECK 0

    gamescope \
        -W 5120 -H 2160 -r 120 \
        --hdr-enabled \
        --hdr-sdr-content-nits 100 \
        --adaptive-sync \
        --fullscreen \
        -e -- \
        steam -gamepadui -forcedesktopui -extest
end
