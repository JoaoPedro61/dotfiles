
local options = {
  ensure_installed = {
    "bash-language-server",
    "htmlbeautifier",
    "angular-language-server",
    "azure-pipelines-language-server",
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
  }, -- not an option from mason.nvim

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return options
