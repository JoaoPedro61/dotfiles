if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("joaopedro61.util.debug").dump(...)
end
vim.print = _G.dd

-- bootstrap lazy.nvim, LazyVim and your plugins
require("joaopedro61.lazy")

-- Source our custom script and helpers
require("joaopedro61.core")
