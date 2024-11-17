-- The following files are imported by lazy.nvim, from the files:
--
-- config.autocmds (~/lua/config/autocmds.lua)
-- config.keymaps (~/lua/config/keymaps.lua)
-- config.options (~/lua/config/options.lua)
--
-- require("joaopedro61.core.options")
-- require("joaopedro61.core.options")
-- require("joaopedro61.core.keymaps")
--
-- If you are not using a NeoVim framework,
-- you can simply uncomment the lines above,
-- and import this file into your root init.lua

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
