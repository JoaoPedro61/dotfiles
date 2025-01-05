return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {
            "lua_ls"
          },
          automatic_installation = true
        }
      }
    },

    config = function()
      require("mason-lspconfig").setup_handlers({
        -- This is a common handler to setup all lsp servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        -- This is a setup lspconfig to the lua_ls server
        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup({
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                  enable = false,
                },
              },
            }
          })
        end

        -- Add custum setup handlers bellow. Ex:
        -- ["rust_analyzer"] = function()
        --   require("rust-tools").setup({})
        -- end
      });
    end
  }
}
