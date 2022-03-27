-- wrap areas of the terminal

local lib = {}

function lib.wrap(x, y, w, h)
  local new = setmetatable({
    at = function(_x, _y)
      term.setCursorPos(x + _x - 1, y + _y - 1)
      return new
    end,
    getSize = function()
      return w, h
    end
  }, {__index = term})

  return new
end

return lib
