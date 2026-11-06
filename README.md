# Arara

A blue, elegant Beamer theme with a Brazil-inspired presentation demo.

[View the demo on GitHub Pages](https://tiagovla.github.io/arara/)

## Themes

| Light | Dark |
| --- | --- |
| ![Light theme preview](https://tiagovla.github.io/arara/demo-preview-light.png) | ![Dark theme preview](https://tiagovla.github.io/arara/demo-preview-dark.png) |

## Build

Install [Just](https://just.systems) and [Tectonic](https://tectonic-typesetting.github.io/), then run:

```sh
just demo
just demo-dark
```

## Use the theme

Copy `src/beamerthemearara.sty` beside your `.tex` file, then add this to its preamble:

```tex
\usetheme{arara}
```

Use `\usetheme[dark]{arara}` for the dark palette.
