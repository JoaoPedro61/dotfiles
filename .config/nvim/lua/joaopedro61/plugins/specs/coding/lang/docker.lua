return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "dockerfile",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "hadolint",
          },
        },
      },
    },
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
}
