local platform = require("joaopedro61.util.platform")
local split = require("joaopedro61.util.split")

---@return boolean?
local shell = function()
  if platform.is_windows() then
    return nil
  end

  local shell_path = os.getenv("SHELL")

  if shell_path then
    local shell_segments = split(shell_path)
    local shell_name = shell_segments[#shell_segments]

    if shell_name then
      return shell_name
    end
  end

  return nil
end

return shell
