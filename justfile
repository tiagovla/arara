export ARARA_OUTPUT_DIRECTORY := invocation_directory()

demo: (_build "light")

demo-dark: (_build "dark")

show: demo
    xdg-open "$ARARA_OUTPUT_DIRECTORY/arara.pdf"

show-dark: demo-dark
    xdg-open "$ARARA_OUTPUT_DIRECTORY/arara-dark.pdf"

check:
    #!/usr/bin/env sh
    set -eu
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/arara-check.XXXXXX")
    trap 'rm -rf "$tmpdir"' 0
    cp tests/theme.tex src/beamerthemearara.sty "$tmpdir/"
    for palette in light dark; do
        options=
        [ "$palette" = light ] || options=dark,
        for progressbar in frametitle foot none; do
            for sectionpage in simple none; do
                printf 'Checking %s / %s / %s\n' "$palette" "$progressbar" "$sectionpage"
                printf '\\PassOptionsToPackage{%sprogressbar=%s,sectionpage=%s}{beamerthemearara}\n\\input{theme.tex}\n' "$options" "$progressbar" "$sectionpage" > "$tmpdir/check.tex"
                tectonic --keep-logs --outdir "$tmpdir" "$tmpdir/check.tex"
                if grep -E 'Overfull \\[hv]box|Missing character:' "$tmpdir/check.log"; then
                    exit 1
                fi
                expected=3
                [ "$sectionpage" = none ] || expected=5
                pages=$(pdfinfo "$tmpdir/check.pdf" | awk '/^Pages:/ { print $2 }')
                [ "$pages" = "$expected" ] || { printf 'Expected %s pages, got %s\n' "$expected" "$pages" >&2; exit 1; }
                pdftotext -layout -nopgbrk "$tmpdir/check.pdf" "$tmpdir/check.txt"
                for text in 'Arara title' 'Reusable subtitle' 'Example author' 'Example institute' 'November 6, 2026'; do
                    grep -Fq "$text" "$tmpdir/check.txt"
                done
                if [ "$sectionpage" = simple ]; then
                    grep -Eq '^[[:space:]]*10[[:space:]]*$' "$tmpdir/check.txt"
                else
                    pdftoppm -f 2 -l 2 -singlefile -scale-to 400 "$tmpdir/check.pdf" "$tmpdir/$palette-$progressbar"
                fi
            done
        done
    done
    different() {
        if cmp -s "$tmpdir/$1.ppm" "$tmpdir/$2.ppm"; then
            printf 'Expected different renderings: %s and %s\n' "$1" "$2" >&2
            exit 1
        fi
    }
    for palette in light dark; do
        different "$palette-frametitle" "$palette-foot"
        different "$palette-frametitle" "$palette-none"
        different "$palette-foot" "$palette-none"
    done
    different light-none dark-none

[private]
_build $palette:
    #!/usr/bin/env sh
    set -eu
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
