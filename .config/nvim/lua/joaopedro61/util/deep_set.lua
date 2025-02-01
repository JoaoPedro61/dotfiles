--- @generic T
--- @generic R
---
--- @param root T[] A table (array) of type `T` to modify.
--- @param path string A dot-separated string representing the path to the value.
--- @param value R The value to set at the specified path.
--- @param override boolean A flag that determines if the value should replace the existing value or be merged.
---
--- @return R? The value set at the specified path, or `nil` if the operation could not be performed.
---
--- @description
--- This function sets a value in a nested table at the location specified by the `path`.
--- If the specified path doesn't exist, intermediate tables are created automatically.
--- The `value` will be set at the path, and the behavior depends on the `override` flag:
---   - If `override` is `false` and `value` is a table, the value will be merged with the existing value at the path using `vim.list_extend`.
---   - If `override` is `true` or `value` is not a table, the existing value will be replaced.
--- If the path is invalid or an intermediate value is not a table, the function will return `nil`.
local deep_set = function(root, path, value, override)
  -- Default override to false if not provided
  override = override or false

  -- Split the path into keys using '.' as a delimiter
  local keys = vim.split(path, ".", { plain = true })
  local target = root or {}

  -- Traverse the path to find the target table
  for i = 1, #keys do
    local k = keys[i]
    -- If the key doesn't exist, initialize it as an empty table
    target[k] = target[k] or {}

    -- If the target is not a table at any point, return nil
    if type(target) ~= "table" then
      return
    end
    -- Move deeper into the table
    target = target[k]
  end

  -- Set the value based on the 'override' flag and the type of 'value'
  if type(value) == "table" and not override then
    -- Merge the value if it's a table and override is false
    target = vim.list_extend(target, value)
  else
    -- Directly set the value if override is true or value is not a table
    target = value
  end

  -- Return the newly set value
  return target
end

return deep_set
