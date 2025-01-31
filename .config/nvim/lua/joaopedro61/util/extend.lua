--- @generic T
---
--- @param target T[]
--- @param key string
--- @param source T[]
--- 
--- @return T[]?
local extend = function(target, key, source)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    target[k] = target[k] or {}
    if type(target) ~= "table" then
      return
    end
    target = target[k]
  end
  return vim.list_extend(target, source)
end

return extend
