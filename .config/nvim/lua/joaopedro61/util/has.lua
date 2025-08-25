--- Checks if a given feature or option is available in Vim.
--- This function wraps the `vim.fn.has()` function and returns `true` if the specified feature is available, or `false` if it is not.
---
--- @param x string: The feature or option to check (e.g., `"python3"`, `"gui_running"`).
--- @return boolean: `true` if the feature is available, `false` if it is not.
local has = function(x)
  return vim.fn.has(x) == 1
end

return has

