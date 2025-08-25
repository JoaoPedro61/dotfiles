local platform = require("joaopedro61.util.platform")

if platform.is_windows() then
  require("joaopedro61.platform.windows")
end

if platform.is_macos() then
  require("joaopedro61.platform.macos")
end

if platform.is_linux() then
  require("joaopedro61.platform.linux")
end

if platform.is_wsl() then
  require("joaopedro61.platform.wsl")
end
