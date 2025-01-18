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
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },

    config = function(_, opts)
      local luasnip = require("luasnip");

      luasnip.setup(opts);

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
              require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end
  }
}
