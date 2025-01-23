--- Merges two tables by copying all elements from the second table (`t2`) into the first table (`t1`).
--- If either of the arguments is not a table, the function returns `nil`.
--- This function modifies the first table in place by adding or updating keys from the second table.
---
--- @param t1 table The first table, which will be updated with values from `t2`.
--- @param t2 table The second table whose key-value pairs will be copied into `t1`.
---
--- @return table? Returns the updated `t1` table if both arguments are tables, or `nil` if either argument is not a table.
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
