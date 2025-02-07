return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {},
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
          require("joaopedro61.plugins.util.format").register({
            name = "conform.nvim",
            priority = 100,
            primary = true,
            format = function(buf)
              require("conform").format({ bufnr = buf })
            end,
            sources = function(buf)
              local ret = require("conform").list_formatters(buf)
              ---@param v conform.FormatterInfo
              return vim.tbl_map(function(v)
                return v.name
              end, ret)
            end,
          })
        end,
      })

      vim.opt.formatexpr = "v:lua.require('joaopedro61.plugins.util.format').formatexpr()"
    end,
  },
}

