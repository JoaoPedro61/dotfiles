--- @generic T
--- @generic R
---
--- @param root T[]: A table (array) of type `T` to search through.
--- @param path string: A dot-separated string representing the path to the value.
--- @param or_value R: The default value to return if the key cannot be found or the path is invalid.
---
--- @return R: The value found at the path if it exists, otherwise returns `or_value`.
---
--- @description:
---
--- This function searches for a value within a nested table `root` using a dot-separated `path`.
--- If any part of the path is invalid (e.g., key does not exist or the intermediate value is not a table),
--- it returns the specified default value (`or_value`).
local deep_find = function(root, path, or_value)
  -- Split the path into keys using '.' as a delimiter
  local keys = vim.split(path, ".", { plain = true })
  local target = root -- The starting point for searching

  -- Iterate through each key in the path
  for _, key in ipairs(keys) do
    -- If the target is not a table or the key doesn't exist, return the default value
    if type(target) ~= "table" or target[key] == nil then
      return or_value
    end
    -- Move to the next level in the table
    target = target[key]
  end

  -- Return the found value if all keys are valid, or the default value if not
  return target
end

return deep_find
