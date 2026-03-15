# fm

Personal site built with [Zola](https://www.getzola.org/) and the [Serene](https://github.com/isunjn/serene) theme.

## Requirements

- [Zola](https://www.getzola.org/)
- [Task](https://taskfile.dev/)
- [Lua](https://www.lua.org/) 5.4+
- TeX Live (for TikZ diagram rendering)
- [ImageMagick](https://imagemagick.org/) (image optimization)
- [cwebp](https://developers.google.com/speed/webp/docs/cwebp) (WebP conversion)

## Authoring

Create a new post:

```
task post -- slicing a pizza the mathematician way
```

This creates `content/posts/slicing-a-pizza-the-mathematician-way/index.md` as a draft with frontmatter ready to edit.

Add a TikZ diagram to a post:

```
task post:tex -- slicing-a-pizza-the-mathematician-way pizza_naive
```

This drops a `.tex` scaffold at `content/posts/slicing-a-pizza-the-mathematician-way/pizza_naive.tex`. Edit it, then run `task tikz` to render to SVG. Reference it in the post with `![caption](pizza_naive.svg)`.

### Images

Source images go in `assets/` mirroring the `static/` structure. Running `task images` (or any build/serve) generates optimized versions in `static/`:

```
assets/img/projects/walden-demo.png
  → static/img/projects/walden-demo.png        (optimized)
  → static/img/projects/walden-demo-thumb.png   (400px thumbnail)
  → static/img/projects/walden-demo.webp        (webp)
  → static/img/projects/walden-demo-thumb.webp  (webp thumbnail)
```

## Tasks

```
task serve              # dev server (pre-renders tikz + images)
task build              # production build
task build:preview      # preview build (Cloudflare Pages)
task deploy             # build + deploy to production
task deploy:preview     # build + deploy preview
task tikz               # pre-render .tex files to SVG
task images             # optimize assets/ images into static/
task post -- my title   # scaffold a new draft post
task post:tex -- slug d # add a .tex diagram to a post
task clean              # remove build output
```
