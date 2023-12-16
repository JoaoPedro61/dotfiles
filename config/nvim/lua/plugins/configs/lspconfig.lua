
dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"
local lspconfig = require "lspconfig"


local HOME_PATH = os.getenv("HOME") or "";
local NODE_VERSION = "v20.9.0";

local handleNodeVersion = io.popen("node -v");

if (handleNodeVersion ~= nil) then
  NODE_VERSION = handleNodeVersion:read();
  handleNodeVersion:close();
end

local GLOBAL_NODE_MODULES = HOME_PATH .. "/.nvm/versions/node/" .. NODE_VERSION .. "/lib/node_modules";



-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
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

------------------------------------------------------
-- Base LSP that no need aditional configurations ----
------------------------------------------------------

local servers = {
  "html",
  "cssls",
  "bashls",
  "azure_pipelines_ls",
  "cssmodules_ls",
  "custom_elements_ls",
  "denols",
  "eslint",
  "htmx",
  "jsonls",
  "rust_analyzer",
  "tailwindcss",
  "tsserver"
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }
end


------------------------------------------------------
-- Put the more complex LSP here that need some ------
-- aditional config ----------------------------------
------------------------------------------------------


lspconfig["lua_ls"].setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}



-- Angular configuration
local CMD_ANGULAR = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations", GLOBAL_NODE_MODULES,
  "--ngProbeLocations", GLOBAL_NODE_MODULES
}

lspconfig["angularls"].setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  cmd = CMD_ANGULAR,
  on_new_config = function(new_config)
    new_config.cmd = CMD_ANGULAR
  end,
}


return M
