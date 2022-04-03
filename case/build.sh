#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

build() (
    if [[ "$1" ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local scad="$(echo "$1" | cut -d':' -f2)"
        local side="$(echo "$1" | cut -d':' -f3)"
        local shroud="$(echo "$1" | cut -d':' -f4)"
        set -x
        openscad --hardwarnings \
            -o "$stl" \
            -D side="\"$side\"" \
            -D shroud="$shroud" \
            "$scad"
    fi
)

export -f build

cat <<EOF | parallel --progress build {} 1>&2
out/left.switchPlate.stl:v1.switchPlate.scad:left:true
out/left.switchPlate.noShroud.stl:v1.switchPlate.scad:left:false
out/left.bottomPlate.stl:v1.bottomPlate.scad:left
out/right.switchPlate.stl:v1.switchPlate.scad:right:true
out/right.switchPlate.noShroud.stl:v1.switchPlate.scad:right:false
out/right.bottomPlate.stl:v1.bottomPlate.scad:right
EOF
