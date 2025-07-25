#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

paste -d '' \
    (fish "$DIR/ness.surprise.fish" | psub) \
    (fish "$DIR/paula.surprise.fish" | psub) \
    (fish "$DIR/jeff.surprise.fish" | psub) \
    (fish "$DIR/poo.surprise.fish" | psub)

