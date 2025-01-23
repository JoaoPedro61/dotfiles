local platform = require("joaopedro61.util.platform")
local split = require("joaopedro61.util.split")

--- Determines the name of the current shell in use (if applicable).
--- This function checks the environment variable `SHELL` to determine the name of the shell, 
--- but only if the platform is not Windows. It returns `nil` if no shell is found or if the platform is Windows.
---
--- @return string?: The name of the shell (e.g., `"bash"`, `"zsh"`), or `nil` if not applicable or the shell cannot be determined.
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
