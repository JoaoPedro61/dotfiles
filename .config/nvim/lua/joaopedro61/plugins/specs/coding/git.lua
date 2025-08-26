return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  vim.fn.executable("lazygit") == 1 and {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "LazyGit",
      },
    },
  },
}
