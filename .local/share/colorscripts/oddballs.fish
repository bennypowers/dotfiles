#!/bin/bash

# This script combines the output of ness, paula, jeff, and poo colorscripts horizontally.
# It reads the output of each script into an array of lines.
# Then, it iterates through the lines of the longest script (ness.sh, 17 lines)
# and prints the corresponding line from each character's script.
# For the shorter scripts, this will print empty strings, effectively padding the output.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mapfile -t a < <(bash "$DIR/mrsaturn.sh")
mapfile -t b < <(bash "$DIR/ness.sleepy.sh")
mapfile -t c < <(bash "$DIR/happycultist.sh")
mapfile -t d < <(bash "$DIR/drandonuts.sh")

for i in {0..16}; do
    printf "%s%s%s%s\n" "${a[$i]}" "${b[$i]}" "${c[$i]}" "${d[$i]}"
done
