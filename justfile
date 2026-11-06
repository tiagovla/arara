demo:
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara.XXXXXX"); trap 'rm -rf "$tmpdir"' 0; cp demo/demo.tex src/beamerthemearara.sty "$tmpdir/"; tectonic --outdir "$tmpdir" "$tmpdir/demo.tex"; cp "$tmpdir/demo.pdf" arara.pdf

show: demo
    xdg-open arara.pdf
