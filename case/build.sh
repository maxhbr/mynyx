#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad git

set -euo pipefail

cd "$(dirname "$0")"

writeVersionScad() {
    local scad="$1"
    local commits="$(git log --follow --oneline "$scad" | wc -l)"
    local modified="$(git diff --exit-code "$scad" &>/dev/null || echo "m")"
    cat <<EOF > _version.scad
git_commit_count="v${commits}${modified}";
EOF
    git add _version.scad
}

build() (
    if [[ "$2" && "$2" != "#"* ]]; then
        local scad="$1"
        local stl="$(echo "$2" | cut -d':' -f1)"
        local variant="$(echo "$2" | cut -d':' -f2)"
        local side="$(echo "$2" | cut -d':' -f3)"
        if [[ -z "$side" ]]; then
            side="left"
        fi
        local var_with_cap="$(echo "$2" | cut -d':' -f4)"
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
            "$scad"

        ast_prev="$ast.prev"
        if cmp --silent "$ast" "$ast_prev"; then
            echo "... already generated $stl"
        else
            ( set -x
              openscad --hardwarnings \
                -o "$stl" \
                -D var_variant="\"$variant\"" \
                -D var_side="\"$side\"" \
                -D var_with_cap="$var_with_cap" \
                "$scad"
            )
            diff "$ast" "$ast_prev" > "$ast.diff"
            cp "$ast" "$ast_prev"
        fi
    fi
)

export -f build

###############################################################################
##  run  ######################################################################
###############################################################################

scad="nyx.scad"

writeVersionScad "$scad"
cat <<EOF | parallel --progress build "$scad" {} 1>&2
out/nyx.left.topCase.stl:shrouded:left:true
out/nyx.left.topPlate.stl:plate:left:true
out/nyx.left.bottomPlate.stl:bottomPlate:left
out/nyx.right.topCase.stl:shrouded:right:true
out/nyx.right.topPlate.stl:plate:right:true
out/nyx.right.bottomPlate.stl:bottomPlate:right
EOF

