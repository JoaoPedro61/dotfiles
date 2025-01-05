return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "lua",
      },
      highlight        = { enable = true },
      indent           = { enable = true },
      auto_install     = true,
    },
    init = function()
      require("nvim-treesitter.query_predicates")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- I should add the "nvim-treesitter/nvim-treesitter-textobjects"??? learn more about it
  -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
