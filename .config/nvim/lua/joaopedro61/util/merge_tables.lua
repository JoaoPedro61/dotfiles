---@param t1 table
---@param t2 table
---@return table?
local merge_tables = function(t1, t2)
  if type(t1) ~= "table" or type(t2) ~= "table" then
    return
  end
  for k, v in pairs(t2) do
    t1[k] = v
  end

  return t1
end

return merge_tables
