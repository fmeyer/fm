#!/usr/bin/env lua
-- Optimize images from assets/ into static/
-- Generates: optimized original, thumbnail (-thumb), and WebP variants

local SRC_DIR = "assets"
local DST_DIR = "static"
local THUMB_WIDTH = 400
local QUALITY = 85
local WEBP_QUALITY = 80

local function mtime(path)
  local h = io.popen(string.format("stat -f '%%m' '%s' 2>/dev/null", path))
  local t = tonumber(h:read("*a")) or 0
  h:close()
  return t
end

local function find_images()
  local files = {}
  local h = io.popen("find " .. SRC_DIR .. " -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \\)")
  for line in h:lines() do
    files[#files + 1] = line
  end
  h:close()
  return files
end

local function mkdirp(path)
  os.execute(string.format("mkdir -p '%s'", path))
end

local function slugify(name)
  -- lowercase, spaces/underscores to hyphens, strip non-uri chars, collapse hyphens
  name = name:lower()
  name = name:gsub("[%s_]+", "-")
  name = name:gsub("[^%w%-%.]", "")
  name = name:gsub("%-+", "-")
  name = name:gsub("^%-", ""):gsub("%-$", "")
  return name
end

local function dst_path(src)
  -- assets/img/projects/Foo Bar.png -> static/img/projects/foo-bar.png
  local dir = src:match("(.+)/[^/]+$") or "."
  local file = src:match("[^/]+$")
  dir = dir:gsub("^" .. SRC_DIR .. "/", DST_DIR .. "/")
  return dir .. "/" .. slugify(file)
end

local function thumb_path(path)
  -- static/img/projects/foo.png -> static/img/projects/foo-thumb.png
  return path:gsub("(%.[^.]+)$", "-thumb%1")
end

local function webp_path(path)
  return path:gsub("%.[^.]+$", ".webp")
end

local function is_fresh(src, outputs)
  local src_t = mtime(src)
  for _, out in ipairs(outputs) do
    if mtime(out) <= src_t then return false end
  end
  return true
end

local function process(src)
  local full = dst_path(src)
  local thumb = thumb_path(full)
  local full_webp = webp_path(full)
  local thumb_webp = webp_path(thumb)

  if is_fresh(src, { full, thumb, full_webp, thumb_webp }) then
    print("skip: " .. src .. " is up to date")
    return
  end

  local dir = full:match("(.+)/[^/]+$") or "."
  mkdirp(dir)

  print("images: " .. src)

  -- optimized full size
  os.execute(string.format(
    "magick '%s' -strip -quality %d '%s'", src, QUALITY, full))

  print("\toptimized: " .. full)

  -- thumbnail
  os.execute(string.format(
    "magick '%s' -strip -quality %d -resize %dx\\> '%s'", src, QUALITY, THUMB_WIDTH, thumb))

  print("\tthumbnail: " .. thumb)

  -- webp variants
  os.execute(string.format(
    "cwebp -q %d '%s' -o '%s' 2>/dev/null", WEBP_QUALITY, full, full_webp))
  os.execute(string.format(
    "cwebp -q %d '%s' -o '%s' 2>/dev/null", WEBP_QUALITY, thumb, thumb_webp))
  print("\twebp: " .. full_webp .. " " .. thumb_webp)
end


local files = find_images()
if #files == 0 then
  print("images: no source images found in " .. SRC_DIR .. "/")
  os.exit(0)
end

for _, src in ipairs(files) do
  process(src)
end
