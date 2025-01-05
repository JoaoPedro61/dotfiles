local platform = require("joaopedro61.util.platform")

return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not platform.is_windows())
        and "make install_jsregexp"
        or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          -- If you need create a custom snippets:
          -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  }
}
