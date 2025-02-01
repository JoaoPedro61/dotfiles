local lsp = require("joaopedro61.plugins.util.lsp")

return {
  { import = "joaopedro61.plugins.specs.coding.lang.css" },
  { import = "joaopedro61.plugins.specs.coding.lang.html" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown", "text" },
          -- add additional filetypes to the default_config
          filetypes_include = {
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact",
          },
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = lsp.get_raw_config("tailwindcss")
          opts.filetypes = opts.filetypes or {}

          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
}
