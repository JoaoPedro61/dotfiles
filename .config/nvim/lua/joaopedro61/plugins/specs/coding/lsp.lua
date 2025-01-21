local ui = require("joaopedro61.ui");
local lsp = require("joaopedro61.util.plugins.coding.lsp");

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
      ui = {
        border = ui.window.get_win_borders(),
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end
  },
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
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      keys = {
        { "<leader>cl", "<cmd>LspInfo<cr>",                                 desc = "Lsp Info" },
        { "gd",         vim.lsp.buf.definition,                             desc = "Goto Definition",            has = "definition" },
        { "gr",         vim.lsp.buf.references,                             desc = "References",                 nowait = true },
        { "gI",         vim.lsp.buf.implementation,                         desc = "Goto Implementation" },
        { "gy",         vim.lsp.buf.type_definition,                        desc = "Goto T[y]pe Definition" },
        { "gD",         vim.lsp.buf.declaration,                            desc = "Goto Declaration" },
        { "K",          function() return vim.lsp.buf.hover() end,          desc = "Hover" },
        { "gK",         function() return vim.lsp.buf.signature_help() end, desc = "Signature Help",             has = "signatureHelp" },
        { "<c-k>",      function() return vim.lsp.buf.signature_help() end, mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action,                            desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
        { "<leader>cc", vim.lsp.codelens.run,                               desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
        { "<leader>cC", vim.lsp.codelens.refresh,                           desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
        { "<leader>cR", function() Snacks.rename.rename_file() end,         desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
        { "<leader>cr", vim.lsp.buf.rename,                                 desc = "Rename",                     has = "rename" },
        -- { "<leader>cA", LazyVim.lsp.action.source,                          desc = "Source Action",              has = "codeAction" },
        {
          "]]",
          function() Snacks.words.jump(vim.v.count1) end,
          has = "documentHighlight",
          desc = "Next Reference",
          cond = function() return Snacks.words.is_enabled() end
        },
        {
          "[[",
          function() Snacks.words.jump(-vim.v.count1) end,
          has = "documentHighlight",
          desc = "Prev Reference",
          cond = function() return Snacks.words.is_enabled() end
        },
        {
          "<a-n>",
          function() Snacks.words.jump(vim.v.count1, true) end,
          has = "documentHighlight",
          desc = "Next Reference",
          cond = function() return Snacks.words.is_enabled() end
        },
        {
          "<a-p>",
          function() Snacks.words.jump(-vim.v.count1, true) end,
          has = "documentHighlight",
          desc = "Prev Reference",
          cond = function() return Snacks.words.is_enabled() end
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = {
          "vue"
        }
      },
      codelens = {
        enabled = true,
        exclude = {
          "vue"
        }
      },
      capabilities = {
        workspace = {
          fileoperations = {
            didrename = true,
            willrename = true,
          },
        },
      },
    },

    config = function(_, opts)
      lsp.setup()

      if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
        lsp.on_supports_method("textdocument/inlayhint", function(_, buffer)
          if lsp.is_valid_buf(buffer, opts.inlay_hints.exclude) then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      if opts.codelens.enabled and vim.lsp.codelens then
        lsp.on_supports_method("textdocument/codelens",
          function(_, buffer)
            if lsp.is_valid_buf(buffer, opts.codelens.exclude) then
              vim.lsp.codelens.refresh()
            end
            vim.api.nvim_create_autocmd({ "bufenter", "cursorhold", "insertleave" }, {
              buffer = buffer,
              callback = function()
                if lsp.is_valid_buf(buffer, opts.codelens.exclude) then
                  vim.lsp.codelens.refresh()
                end
              end,
            })
          end)
      end

      local capabilities = lsp.get_default_capabilities(opts.capabilities)

      require("mason-lspconfig").setup_handlers({
        -- this is a common handler to setup all lsp servers
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = vim.deepcopy(capabilities),
          })
        end,

        -- this is a setup lspconfig to the lua_ls server
        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup({
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
                telemetry = {
                  enable = false,
                },
              },
            },
            capabilities = vim.deepcopy(capabilities),
          })
        end
      });
    end
  }
}
