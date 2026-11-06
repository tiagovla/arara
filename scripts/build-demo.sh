#!/usr/bin/env sh
set -eu

palette=$1
case "$palette" in
    light) suffix=; options= ;;
    dark) suffix=-dark; options=dark ;;
    *) printf 'Unknown palette: %s\n' "$palette" >&2; exit 1 ;;
esac
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara.XXXXXX")
trap 'rm -rf "$tmpdir"' 0
cp demo/demo.tex src/beamerthemearara.sty "$tmpdir/"
printf '%s\n' "\PassOptionsToPackage{$options}{beamerthemearara}" '\input{demo.tex}' > "$tmpdir/build.tex"
tectonic --outdir "$tmpdir" "$tmpdir/build.tex"
cp "$tmpdir/build.pdf" "$ARARA_OUTPUT_DIRECTORY/arara$suffix.pdf"
