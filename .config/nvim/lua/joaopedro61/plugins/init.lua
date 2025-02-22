local settings = require("joaopedro61.settings")

require("lazy").setup({
  spec = {
    -- import/override with your plugins
    { import = "joaopedro61.plugins.specs" },
    { import = "joaopedro61.plugins.specs.ui" },
    { import = "joaopedro61.plugins.specs.editor" },
    { import = "joaopedro61.plugins.specs.coding" },
    { import = "joaopedro61.plugins.specs.coding.lang" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    missing = true,
    colorscheme = { settings.safe_get("colorscheme.name", "default") },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = require("joaopedro61.util.disable_builtin").disabled_builtin,
    },
  },
  ui = {
    border = require("joaopedro61.util.ui").get_win_borders(),
    custom_keys = {
      ["<localleader>d"] = function(plugin)
        dd(plugin)
      end,
    },
  },
})
