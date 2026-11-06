demo:
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara.XXXXXX"); dest="${TMPDIR:-/tmp}/arara.pdf"; trap 'rm -rf "$tmpdir"' 0; cp demo/demo.tex src/beamerthemearara.sty "$tmpdir/"; tectonic --outdir "$tmpdir" "$tmpdir/demo.tex"; cp "$tmpdir/demo.pdf" "$dest"

show: demo
    xdg-open "${TMPDIR:-/tmp}/arara.pdf"
