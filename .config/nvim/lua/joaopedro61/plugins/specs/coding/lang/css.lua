return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "scss",
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
        css = {
          "prettier",
        },
        scss = {
          "prettier",
        },
        less = {
          "prettier",
        }
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        css_variables = {},
        cssmodules_ls = {},
      },
    },
  },
}
