local has = require("joaopedro61.util.has")

local M = {}

--- Checks if the current system is Windows.
--- This function checks if the `win32` feature is available in Vim to determine if the system is Windows.
---
--- @return boolean: `true` if the system is Windows, `false` otherwise.
function M.is_windows()
  return has("win32")
end

--- Checks if the current system is macOS.
--- This function checks if the `macunix` feature is available in Vim to determine if the system is macOS.
---
--- @return boolean: `true` if the system is macOS, `false` otherwise.
function M.is_macos()
  return has("macunix")
end

--- Checks if the current system is Linux.
--- This function checks if the `unix` feature is available in Vim to determine if the system is Linux.
---
--- @return boolean: `true` if the system is Linux, `false` otherwise.
function M.is_linux()
  return has("unix")
end

--- Checks if the current system is WSL (Windows Subsystem for Linux).
--- This function checks if the system is Linux and if the `WSL_INTEROP` environment variable is set, which indicates WSL.
---
--- @return boolean: `true` if the system is WSL, `false` otherwise.
function M.is_wsl()
  if M.is_linux() and os.getenv("WSL_INTEROP") then
    return true
  end
  return false
end

return M
