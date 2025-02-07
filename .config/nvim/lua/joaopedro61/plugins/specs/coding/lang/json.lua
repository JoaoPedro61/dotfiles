return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "json",
        "jsonc",
        "json5",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "prettier",
          },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        json = {
          "prettier",
        },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}
