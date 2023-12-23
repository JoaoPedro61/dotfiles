local HOME_PATH = os.getenv("HOME") or ""
local NODE_VERSION = "v20.9.0"

local handleNodeVersion = io.popen("node -v")

if handleNodeVersion ~= nil then
  NODE_VERSION = handleNodeVersion:read()
  handleNodeVersion:close()
end

local GLOBAL_NODE_MODULES = HOME_PATH .. "/.nvm/versions/node/" .. NODE_VERSION .. "/lib/node_modules"

local CMD_ANGULAR = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  GLOBAL_NODE_MODULES,
  "--ngProbeLocations",
  GLOBAL_NODE_MODULES,
}

local function on_attach(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

return {
  -- Mason tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "htmlbeautifier",
        "angular-language-server",
        "azure-pipelines-language-server",
        "selene",
        "luacheck",
        "clang-format",
        "clangd",
        "codespell",
        "css-lsp",
        "cssmodules-language-server",
        "eslint-lsp",
        "html-lsp",
        "htmx-lsp",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "rust-analyzer",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
        "shellcheck",
        "shfmt",
        "flake8",
      })
    end,
  },

  -- LSP Server Settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },

      ---@type lspconfig.options
      servers = {
        pyright = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        html = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        cssls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        bashls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        azure_pipelines_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        cssmodules_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        eslint = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        htmx = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        jsonls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        rust_analyzer = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        angularls = {
          on_attach = on_attach,
          capabilities = capabilities,

          cmd = CMD_ANGULAR,
          on_new_config = function(new_config)
            new_config.cmd = CMD_ANGULAR
          end,
        },
        yamlls = {
          on_attach = on_attach,
          capabilities = capabilities,

          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          on_attach = on_attach,
          capabilities = capabilities,

          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        tailwindcss = {
          on_attach = on_attach,
          capabilities = capabilities,

          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          on_attach = on_attach,
          capabilities = capabilities,

          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Remove Unused Imports",
            },
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            completion = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      setup = {},
    },
  },
}
