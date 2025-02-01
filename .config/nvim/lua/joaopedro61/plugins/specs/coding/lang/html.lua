return {
  { import = "joaopedro61.plugins.specs.coding.lang.css" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
      },
    },
  },
}
