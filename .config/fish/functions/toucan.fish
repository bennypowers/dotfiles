function toucan -d "Build and flash Toucan keyboard firmware"
    set -l workspace /home/bennyp/Developer/zmk/workspace
    set -l board seeeduino_xiao_ble
    set -l extra_modules /home/bennyp/Developer/zmk/toucan-module
    set -l label (set -q ZMK_BOOT_LABEL; and echo $ZMK_BOOT_LABEL; or echo XIAO-BOOT)

    if test (count $argv) -lt 1
        echo "Usage: toucan <command> [side]" >&2
        echo "" >&2
        echo "Commands:" >&2
        echo "  build [left|right|both]   Build firmware (default: both)" >&2
        echo "  flash <left|right>        Wait for bootloader and flash" >&2
        return 1
    end

    # Add venv to PATH for west
    set -gx PATH $workspace/../.venv/bin $PATH

    # West must run from inside the workspace
    set -l old_pwd (pwd)
    cd $workspace

    switch $argv[1]
        case build
            set -l side (test (count $argv) -ge 2; and echo $argv[2]; or echo both)
            switch $side
                case left
                    _toucan_build left $workspace $board $extra_modules
                case right
                    _toucan_build right $workspace $board $extra_modules
                case both
                    _toucan_build left $workspace $board $extra_modules
                    and _toucan_build right $workspace $board $extra_modules
                case '*'
                    echo "Unknown side: $side" >&2
                    cd $old_pwd
                    return 1
            end
        case flash
            if test (count $argv) -lt 2
                echo "Usage: toucan flash <left|right>" >&2
                cd $old_pwd
                return 1
            end
            _toucan_flash $argv[2] $workspace $label
        case '*'
            echo "Unknown command: $argv[1]" >&2
            cd $old_pwd
            return 1
    end

    set -l ret $status
    cd $old_pwd
    return $ret
end

function _toucan_build
    set -l side $argv[1]
    set -l workspace $argv[2]
    set -l board $argv[3]
    set -l extra_modules $argv[4]
    set -l build_dir $workspace/build/$side

    if test -d $build_dir
        echo "Building $side (incremental)..."
        west build -d $build_dir
    else
        echo "Building $side (initial)..."
        switch $side
            case left
                west build -s $workspace/zmk/app -b $board -d $build_dir \
                    -S studio-rpc-usb-uart -- \
                    -DSHIELD="toucan_left rgbled_adapter nice_view_gem" \
                    -DZMK_CONFIG="$workspace/config" \
                    -DZMK_EXTRA_MODULES="$extra_modules" \
                    -DCONFIG_ZMK_STUDIO=y
            case right
                west build -s $workspace/zmk/app -b $board -d $build_dir -- \
                    -DSHIELD="toucan_right rgbled_adapter" \
                    -DZMK_CONFIG="$workspace/config" \
                    -DZMK_EXTRA_MODULES="$extra_modules"
        end
    end

    or return $status
    echo "$side: $build_dir/zephyr/zmk.uf2"
end

function _toucan_flash
    set -l side $argv[1]
    set -l workspace $argv[2]
    set -l label $argv[3]
    set -l uf2 $workspace/build/$side/zephyr/zmk.uf2

    if not test -f $uf2
        echo "No firmware found at $uf2" >&2
        echo "Run 'toucan build $side' first." >&2
        return 1
    end

    set -l dev /dev/disk/by-label/$label
    echo "Waiting for $label..."
    while not test -e $dev
        sleep 0.2
    end

    echo "Mounting..."
    set -l mount_line (udisksctl mount -b $dev 2>&1)
    set -l mount_point (string replace -r '.*at ' '' -- $mount_line | string trim -c '.')

    echo "Copying $side firmware..."
    cp $uf2 $mount_point/
    sync

    echo "Done! Device will reset automatically."
end
