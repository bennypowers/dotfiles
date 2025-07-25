#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

paste -d '' \
    (fish "$DIR/mrsaturn.fish" | psub) \
    (fish "$DIR/ness.sleepy.fish" | psub) \
    (fish "$DIR/happycultist.fish" | psub) \
    (fish "$DIR/drandonuts.fish" | psub)

