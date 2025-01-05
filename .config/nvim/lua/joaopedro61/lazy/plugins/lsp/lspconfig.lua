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
      },

      -- Add support to completions.
      -- See: ~/lua/joaopedro61/lazy/plugins/coding/completion.lua
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      local capabilities = vim.tbl_deep_extend("keep", require("cmp_nvim_lsp").default_capabilities(), {
        -- Put your other defaults capabilities here
      })

      require("mason-lspconfig").setup_handlers({
        -- This is a common handler to setup all lsp servers
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
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
            },
            capabilities = capabilities
          })
        end

        -- Add custum setup handlers bellow. Ex:
        -- ["rust_analyzer"] = function()
        --   require("rust-tools").setup({})
        -- end
      });


      -- This is a temporary keymap
      local keymap = vim.keymap
      keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Formats the current buffer (LSP)", silent = true, noremap = true })
    end
  }
}
