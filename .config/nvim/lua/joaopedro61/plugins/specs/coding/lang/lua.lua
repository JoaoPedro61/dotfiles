return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
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
            "stylua",
            "shfmt",
          },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim", "nvim_bufferline", "Snacks" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              codeLens = {
                enable = true,
              },
              telemetry = {
                enable = false,
              },
              hint = {
                enable = true,
                setType = true,
                paramType = true,
                paramName = "All",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },
}
