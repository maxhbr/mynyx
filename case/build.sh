#!/usr/bin/env bash

set -euo pipefail

scad=v1.scad

build() (
    stl="$1"
    part="$2"
    mirror="$3"
    set -x
    openscad --hardwarnings \
        -o "$stl" \
        -D part="\"$part\"" \
        -D mirror="\"$mirror\"" \
        "$scad"
)

build out/switchPlate.left.stl "switchPlate" "false"
build out/switchPlate.right.stl "switchPlate" "true"
build out/bottomPlate.left.stl "bottomPlate" "true"
build out/bottomPlate.right.stl "bottomPlate" "false"
