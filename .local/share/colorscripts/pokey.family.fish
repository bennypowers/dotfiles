#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

paste -d '' \
    (fish "$DIR/aloysius.fish" | psub) \
    (fish "$DIR/lardna.fish" | psub) \
    (fish "$DIR/pokey.fish" | psub) \
    (fish "$DIR/picky.fish" | psub)

