#!/usr/bin/env bash

set -euo pipefail

build() (
    stl="$1"
    scad="$2"
    mirror="$3"
    set -x
    openscad --hardwarnings \
        -o "$stl" \
        -D side="\"$mirror\"" \
        "$scad"
)

build out/switchPlate.left.stl "v1.switchPlate.scad" "left"
build out/switchPlate.right.stl "v1.switchPlate.scad" "right"
build out/bottomPlate.left.stl "v1.bottomPlate.scad" "left"
build out/bottomPlate.right.stl "v1.bottomPlate.scad" "right"
