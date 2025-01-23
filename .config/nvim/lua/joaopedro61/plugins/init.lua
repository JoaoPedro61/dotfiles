local ui = require("joaopedro61.ui");

require("lazy").setup({
  spec = {
    { import = "joaopedro61.plugins.specs" },
    { import = "joaopedro61.plugins.specs.ui" },
    { import = "joaopedro61.plugins.specs.coding" },
    { import = "joaopedro61.plugins.specs.coding.lang" },
    { import = "joaopedro61.plugins.specs.editor" },
  },
  defaults = {
    lazy = false,
    version = false,
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { missing = true, colorscheme = { "default" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true
    }
  },
  change_detection = {
    enabled = true,
  },
  state = vim.fn.stdpath("state") .. "/lazy/state.json",
  ui = {
    border = ui.window.get_win_borders(),

    custom_keys = {
      ["<localleader>d"] = function(plugin)
        dd(plugin)
      end,
    },
  },
})
