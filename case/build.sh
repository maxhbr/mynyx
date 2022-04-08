#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad git

set -euo pipefail

cd "$(dirname "$0")"

writeVersionScad() {
    cat <<EOF > _version.scad
git_describe="$(git describe --tags --abbrev=2)";
git_commit_count="#C=$(git log --oneline "v1.scad" | wc -l)";
EOF
    git add _version.scad
}
writeVersionScad

build() (
    if [[ "$1" && "$1" != "#"* ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local variant="$(echo "$1" | cut -d':' -f2)"
        local side="$(echo "$1" | cut -d':' -f3)"
        if [[ -z "$side" ]]; then
            side="left"
        fi
        local var_with_cap="$(echo "$1" | cut -d':' -f4)"
        if [[ -z "$var_with_cap" ]]; then
            var_with_cap=true
        fi
        mkdir -p "$(dirname "$stl")"
        mkdir -p "ast/$(dirname "$stl")"

        local ast="ast/${stl%.*}.ast"
        openscad --hardwarnings \
            -o "$ast" \
            -D var_variant="\"$variant\"" \
            -D var_side="\"$side\"" \
            -D var_with_cap="$var_with_cap" \
            "v1.scad"

        ast_prev="$ast.prev"
        if cmp --silent "$ast" "$ast_prev"; then
            echo "... already generated $stl"
        else
            set -x
            openscad --hardwarnings \
                -o "$stl" \
                -D var_variant="\"$variant\"" \
                -D var_side="\"$side\"" \
                -D var_with_cap="$var_with_cap" \
                "v1.scad"
            cp "$ast" "$ast_prev"
        fi
    fi
)

export -f build

cat <<EOF | parallel --progress build {} 1>&2
out/left.topCase.stl:shrouded:left:true
out/left.topPlate.stl:plate:left:true
out/left.bottomPlate.stl:bottomPlate:left
out/right.topCase.stl:shrouded:right:true
out/right.topPlate.stl:plate:right:true
out/right.bottomPlate.stl:bottomPlate:right
EOF

