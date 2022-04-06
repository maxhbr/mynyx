#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

build() (
    if [[ "$1" && "$1" != "#"* ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local variant="$(echo "$1" | cut -d':' -f2)"
        local side="$(echo "$1" | cut -d':' -f3)"
        # local var_with_cap="$(echo "$1" | cut -d':' -f4)"
        set -x
        mkdir -p "$(dirname "$stl")"
        openscad --hardwarnings \
            -o "$stl" \
            -D var_side="\"$side\"" \
            -D var_variant="\"$variant\"" \
            "./v1.scad"
    fi
)

export -f build

cat <<EOF | parallel --progress build {} 1>&2
out/left.topCase.stl:shrouded:left
out/left.topPlate.stl:plate:left
#out/left.topPlate.no-thumb-cluster.stl:no-thumb-cluster:left
out/left.bottomPlate.stl:bottomPlate:left
out/right.topCase.stl:shrouded:right
out/right.topPlate.stl:plate:right
#out/right.topPlate.no-thumb-cluster.stl:no-thumb-cluster:right
out/right.bottomPlate.stl:bottomPlate:right
EOF

