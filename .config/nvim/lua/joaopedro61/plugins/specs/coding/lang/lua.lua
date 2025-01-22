return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      }
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "snacks.nvim",        words = { "Snacks" } },
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
            lua = {
              runtime = {
                version = "luajit",
              },
              diagnostics = {
                globals = { "vim", "nvim_bufferline" },
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
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      }
    }
  }
}
