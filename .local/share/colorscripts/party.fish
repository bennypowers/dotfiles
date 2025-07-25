#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

paste -d '' \
    (fish "$DIR/ness.v.fish" | psub) \
    (fish "$DIR/paula.fish" | psub) \
    (fish "$DIR/jeff.fish" | psub) \
    (fish "$DIR/poo.fish" | psub)

