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
  for index, key in ipairs(keys) do
    if index ~= #keys then
      -- If the key doesn't exist, initialize it as an empty table
      if target[key] == nil then
        target[key] = {} -- Create an empty table if the key doesn't exist
      end
      -- Move deeper into the table
      target = target[key]
    end
  end

  if type(target) ~= "table" then
    return
  end

  local last_key = keys[#keys]

  if override then
    -- Simply set the value
    target[last_key] = value
  else
    -- Extend the value (assuming tables and values can be merged)
    if type(target) == "table" and type(value) == "table" then
      for k, v in pairs(value) do
        target[k] = v
      end
    else
      -- If override is false and not both values are tables, set the value
      target[last_key] = value
    end
  end

  -- Return the newly set value
  return target[last_key]
end

return deep_set
