demo:
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara.XXXXXX"); dest="$(pwd)/arara.pdf"; trap 'rm -rf "$tmpdir"' 0; cp demo/demo.tex src/beamerthemearara.sty "$tmpdir/"; tectonic --outdir "$tmpdir" "$tmpdir/demo.tex"; cp "$tmpdir/demo.pdf" "$dest"

demo-dark:
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara.XXXXXX"); dest="$(pwd)/arara-dark.pdf"; trap 'rm -rf "$tmpdir"' 0; sed 's/progressbar=frametitle,sectionpage=none/dark,progressbar=frametitle,sectionpage=none/' demo/demo.tex > "$tmpdir/demo.tex"; cp src/beamerthemearara.sty "$tmpdir/"; tectonic --outdir "$tmpdir" "$tmpdir/demo.tex"; cp "$tmpdir/demo.pdf" "$dest"

show: demo
    xdg-open "$(pwd)/arara.pdf"

show-dark: demo-dark
    xdg-open "$(pwd)/arara-dark.pdf"
