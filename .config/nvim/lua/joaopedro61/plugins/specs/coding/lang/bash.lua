return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.filetype.add({
        pattern = {
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })

      table.insert(opts.ensure_installed, "git_config")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck"
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
}
