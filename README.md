# fm

Personal site built with [Zola](https://www.getzola.org/) and the [Serene](https://github.com/isunjn/serene) theme.

## Requirements

- [Zola](https://www.getzola.org/)
- [Task](https://taskfile.dev/)
- [Lua](https://www.lua.org/) 5.4+
- TeX Live (for TikZ diagram rendering)

## Tasks

```
task serve              # dev server (pre-renders tikz first)
task build              # production build
task build:preview      # preview build (Cloudflare Pages)
task deploy             # build + deploy to production
task deploy:preview     # build + deploy preview
task tikz               # pre-render .tex files to SVG
task post -- my title   # scaffold a new draft post
task post:tex -- slug d # add a .tex diagram to a post
task clean              # remove build output
```
