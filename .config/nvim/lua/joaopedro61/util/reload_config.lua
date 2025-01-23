--- Reloads the Neovim configuration by sourcing the `init.lua` file.
--- This function constructs the path to the Neovim configuration file using `vim.fn.stdpath("config")`, 
--- then it runs the `:source` command to reload the configuration.
---
--- @return nil
local reload_config = function()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  vim.cmd(":source " .. config_path)
end

return reload_config
