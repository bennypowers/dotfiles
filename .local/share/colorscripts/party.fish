#!/bin/bash

# This script combines the output of ness, paula, jeff, and poo colorscripts horizontally.
# It reads the output of each script into an array of lines.
# Then, it iterates through the lines of the longest script (ness.sh, 17 lines)
# and prints the corresponding line from each character's script.
# For the shorter scripts, this will print empty strings, effectively padding the output.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mapfile -t ness_lines < <(bash "$DIR/ness.v.sh")
mapfile -t paula_lines < <(bash "$DIR/paula.sh")
mapfile -t jeff_lines < <(bash "$DIR/jeff.sh")
mapfile -t poo_lines < <(bash "$DIR/poo.sh")

for i in {0..16}; do
    printf "%s%s%s%s\n" "${ness_lines[$i]}" "${paula_lines[$i]}" "${jeff_lines[$i]}" "${poo_lines[$i]}"
done
