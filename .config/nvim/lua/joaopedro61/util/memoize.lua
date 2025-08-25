--- @alias joaopedro61.Util.MemoizeCache table<(fun()), table<string, any>>

local memoize_cache = {} --- @type joaopedro61.Util.MemoizeCache

--- @generic T: fun()
---
--- @param fn T
---
--- @return T
local memoize = function(fn)
  return function(...)
    local key = vim.inspect({ ... })
    memoize_cache[fn] = memoize_cache[fn] or {}
    if memoize_cache[fn][key] == nil then
      memoize_cache[fn][key] = fn(...)
    end
    return memoize_cache[fn][key]
  end
end

return memoize;

