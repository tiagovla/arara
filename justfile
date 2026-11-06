export ARARA_OUTPUT_DIRECTORY := invocation_directory()

demo: (_build "light")

demo-dark: (_build "dark")

show: demo
    xdg-open "$ARARA_OUTPUT_DIRECTORY/arara.pdf"

show-dark: demo-dark
    xdg-open "$ARARA_OUTPUT_DIRECTORY/arara-dark.pdf"

check:
    sh scripts/check-theme.sh

[private]
_build $palette:
    sh scripts/build-demo.sh "$palette"
