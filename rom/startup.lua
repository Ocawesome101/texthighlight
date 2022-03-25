-- Start TextHighlight --

local version = 0.1

local syntax = dofile("/rom/syntax.lua")
local wrapper = dofile("/rom/wrapper.lua")

term.setWindowTitle("TextHighlight v"..version)

-- Mount the root directory.
mounter.mount("/", "/")

local w, h = term.getSize()
local ftree = wrapper.wrap(1, 1, 32, h)

local wrappers = {
  ftree, editor
}

while true do coroutine.yield() end
