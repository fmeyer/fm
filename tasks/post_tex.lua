#!/usr/bin/env lua
-- Add a .tex diagram scaffold to an existing post
-- usage: lua scripts/post_tex.lua <post-slug> <diagram-name>

local post_slug = arg[1]
local diagram_name = arg[2]

if not post_slug or not diagram_name then
  io.stderr:write("usage: lua scripts/post_tex.lua <post-slug> <diagram-name>\n")
  os.exit(1)
end

local dir = "content/posts/" .. post_slug

-- check post exists
local h = io.popen("test -d '" .. dir .. "' && echo yes || echo no")
local exists = h:read("*l")
h:close()

if exists ~= "yes" then
  io.stderr:write("error: post not found: " .. dir .. "\n")
  os.exit(1)
end

local path = dir .. "/" .. diagram_name .. ".tex"
local f = io.open(path, "r")
if f then
  f:close()
  io.stderr:write("error: " .. path .. " already exists\n")
  os.exit(1)
end

f = assert(io.open(path, "w"))
f:write([[\documentclass[border=2pt]{standalone}
\usepackage{tikz}
\begin{document}
\begin{tikzpicture}
  % your diagram here
\end{tikzpicture}
\end{document}
]])
f:close()

print("created: " .. path)
print("render:  task tikz")
print("use:     ![caption](" .. diagram_name .. ".svg)")
