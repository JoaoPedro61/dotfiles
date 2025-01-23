--- Splits a string into a table of substrings based on a given separator.
--- If no separator is provided, it defaults to whitespace (`%s`).
--- This function uses `string.gmatch` to iterate through the input string and break it into substrings.
---
--- @param inputstr string: The input string to split.
--- @param sep string?: The separator used to split the string (optional). If not provided, the default separator is any whitespace character (`%s`).
---
--- @return table: A table containing the substrings obtained by splitting `inputstr` by the separator.
local split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return split
