#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

build() (
    if [[ "$1" && "$1" != "#"* ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local scad="$(echo "$1" | cut -d':' -f2)"
        local side="$(echo "$1" | cut -d':' -f3)"
        local shroud="$(echo "$1" | cut -d':' -f4)"
        set -x
        mkdir -p "$(dirname "$stl")"
        openscad --hardwarnings \
            -o "$stl" \
            -D var_side="\"$side\"" \
            -D var_variant="\"$shroud\"" \
            "$scad"
    fi
)

export -f build

cat <<EOF | parallel --progress build {} 1>&2
out/left.topCase.stl:v1.switchPlate.scad:left:shrouded
out/left.topPlate.stl:v1.switchPlate.scad:left:plate
#out/left.topPlate.no-thumb-cluster.stl:v1.switchPlate.scad:left:no-thumb-cluster
out/left.bottomPlate.stl:v1.bottomPlate.scad:left
out/right.topCase.stl:v1.switchPlate.scad:right:shrouded
out/right.topPlate.stl:v1.switchPlate.scad:right:plate
#out/right.topPlate.no-thumb-cluster.stl:v1.switchPlate.scad:right:no-thumb-cluster
out/right.bottomPlate.stl:v1.bottomPlate.scad:right
EOF

