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
