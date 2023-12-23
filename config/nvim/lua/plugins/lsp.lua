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
        pyright = {},
        html = {},
        cssls = {},
        bashls = {},
        azure_pipelines_ls = {},
        cssmodules_ls = {},
        eslint = {},
        htmx = {},
        jsonls = {},
        rust_analyzer = {},
        angularls = {
          cmd = CMD_ANGULAR,
          on_new_config = function(new_config)
            new_config.cmd = CMD_ANGULAR
          end,
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
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
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
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
          },
        },
      },
      setup = {},
    },
  },
}
