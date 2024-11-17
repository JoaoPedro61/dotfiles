local has = require("joaopedro61.util.has")

local M = {}

function M.is_windows()
  return has("win32")
end

function M.is_macos()
  return has("macunix")
end

function M.is_linux()
  return has("unix")
end

function M.is_wsl()
  if M.is_linux() and os.getenv("WSL_INTEROP") then
    return true
  end
  return false
end

return M
