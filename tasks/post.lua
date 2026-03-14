#!/usr/bin/env lua
-- Create a new blog post scaffold

local args = table.concat(arg, " ")
if args == "" then
  io.stderr:write("usage: lua scripts/post.lua my post title\n")
  os.exit(1)
end

local slug = args:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")
if slug == "" then
  io.stderr:write("error: could not derive slug from title\n")
  os.exit(1)
end

local dir = "content/posts/" .. slug
os.execute("mkdir -p '" .. dir .. "'")

local path = dir .. "/index.md"
local f = io.open(path, "r")
if f then
  f:close()
  io.stderr:write("error: " .. path .. " already exists\n")
  os.exit(1)
end

local date = os.date("%Y-%m-%d")

f = assert(io.open(path, "w"))
f:write(string.format([[+++
title = "%s"
date = %s
draft = true
[taxonomies]
tags = []
[extra]
math = false
toc = false
+++
]], args, date))
f:close()

print("created: " .. path)
