-- Load TextEdit, but first provide a couple things

-- Argument checking!
function _G.checkArg(n, have, ...)
  have = type(have)
  local function check(want, ...)
    if not want then
      return false
    else
      return have == want or check(...)
    end
  end
  if not check(...) then
    local aname
    if type(n) == "number" then
      aname = string.format("#%d", n)
    else
      aname = string.format("'%s'", n)
    end
    error(debug.traceback(string.format("bad argument %s (expected %s, got %s)",      aname, table.concat({...}, " or "), have), 3))
  end
end

if _VERSION == "Lua 5.1" then
  -- Make it more like 5.2
  local setfenv = setfenv
  local oldload = load
  local loadstring = loadstring
  _G.getfenv = nil
  _G.setfenv = nil
  _G.loadstring = nil
  _G.unpack = nil
  _G.math.log10 = nil
  _G.table.maxn = nil

  function _G.load(x, name, mode, env)
    checkArg(1, x, "string", "function")
    checkArg(2, name, "string", "nil")
    checkArg(3, mode, "string", "nil")
    checkArg(4, env, "table", "nil")
    env = env or _G

    local result, err
    if type(x) == "string" then
      result, err = loadstring(x, name)
    else
      result, err = oldload(x, name)
    end
    if result then
      env._ENV = env
      setfenv(result, env)
    end
    return result, err
  end
end

-- provide term.at()
-- this allows for e.g. term.at(2,3).write("nice")
function term.at(x,y)
  checkArg(1, x, "number")
  checkArg(2, y, "number")
  term.setCursorPos(x,y)
  return term
end

function term.fg(i)
  checkArg(1, i, "number")
  term.setTextColor(2^(i-1))
  return term
end

function term.bg(i)
  checkArg(1, i, "number")
  term.setBackgroundColor(2^(i-1))
  return term
end

-- provide loadfile() and dofile()
function _G.loadfile(f, mode, env)
  checkArg(1, f, "string")
  checkArg(2, mode, "string", "nil")
  checkArg(3, env, "table", "nil")

  local handle = assert(fs.open(f, "r"))
  local data = handle.readAll()
  handle.close()

  return load(data, "="..f, mode or "t", env or _G)
end

function _G.dofile(file)
  checkArg(1, file, "string")
  return assert(loadfile(file))()
end

assert(loadfile("/rom/startup.lua"))()
