if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("joaopedro61.util.debug").dump(...)
end
vim.print = _G.dd

-- Source our custom script and helpers
require("joaopedro61")
