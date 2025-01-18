local reload_config = function()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  vim.cmd(":source " .. config_path)
end

return reload_config
