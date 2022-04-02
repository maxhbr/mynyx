#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

build() (
    if [[ "$1" ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local scad="$(echo "$1" | cut -d':' -f2)"
        local side="$(echo "$1" | cut -d':' -f3)"
        set -x
        openscad --hardwarnings \
            -o "$stl" \
            -D side="\"$side\"" \
            "$scad"
    fi
)

export -f build

cat <<EOF | parallel --progress build {} 1>&2
out/switchPlate.left.stl:v1.switchPlate.scad:left
out/switchPlate.right.stl:v1.switchPlate.scad:right
out/bottomPlate.left.stl:v1.bottomPlate.scad:left
out/bottomPlate.right.stl:v1.bottomPlate.scad:right
EOF
