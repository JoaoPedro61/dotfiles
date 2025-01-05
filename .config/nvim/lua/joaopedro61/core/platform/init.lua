local platform = require("joaopedro61.util.platform")

if platform.is_windows() then
  require("joaopedro61.core.platform.windows")
end

if platform.is_macos() then
  require("joaopedro61.core.platform.macos")
end

if platform.is_linux() then
  require("joaopedro61.core.platform.linux")
end

if platform.is_wsl() then
  require("joaopedro61.core.platform.wsl")
end
