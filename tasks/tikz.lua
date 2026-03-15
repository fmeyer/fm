#!/usr/bin/env lua
-- Pre-render .tex files under content/ to SVG

local function exec(cmd)
  local h = io.popen(cmd)
  local out = h:read("*a")
  h:close()
  return out
end

local function mtime(path)
  -- use stat to get modification time; returns 0 if file missing
  local h = io.popen(string.format("stat -f '%%m' '%s' 2>/dev/null", path))
  local t = tonumber(h:read("*a")) or 0
  h:close()
  return t
end

local function find_tex_files()
  local files = {}
  local h = io.popen("find content -name '*.tex'")
  for line in h:lines() do
    files[#files + 1] = line
  end
  h:close()
  return files
end

local function render(tex)
  local svg = tex:gsub("%.tex$", ".svg")
  if mtime(svg) > mtime(tex) then
    print("skip: " .. svg .. " is up to date")
    return
  end

  local dir = tex:match("(.+)/[^/]+$") or "."
  local base = tex:match("([^/]+)%.tex$")

  print("render: " .. tex .. " -> " .. svg)
  os.execute(string.format(
    "pdflatex -interaction=nonstopmode -output-directory='%s' '%s' > /dev/null 2>&1", dir, tex))
  os.execute(string.format(
    "dvisvgm --pdf '%s/%s.pdf' -o '%s' --no-fonts > /dev/null 2>&1", dir, base, svg))
  -- clean up intermediate files
  for _, ext in ipairs({ "aux", "log", "pdf" }) do
    os.remove(dir .. "/" .. base .. "." .. ext)
  end
end

local files = find_tex_files()
if #files == 0 then
  print("tikz: no .tex files found")
  os.exit(0)
end

for _, tex in ipairs(files) do
  render(tex)
end
