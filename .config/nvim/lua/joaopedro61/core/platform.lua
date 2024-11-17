local platform = require("joaopedro61.util.platform")

if platform.is_windows() then
  require("joaopedro61.core.windows")
end

if platform.is_macos() then
  require("joaopedro61.core.macos")
end

if platform.is_linux() then
  require("joaopedro61.core.linux")
end

if platform.is_wsl() then
  require("joaopedro61.core.wsl")
end
