return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end
  }
}
