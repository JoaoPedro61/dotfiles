return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    event = "BufRead",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = { },
      auto_install = true,
      autopairs = { enable = true },
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      rainbow = {
        enable = true,
        extended_mode = false,
        max_file_lines = nil,
      },
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- I should add the "nvim-treesitter/nvim-treesitter-textobjects"??? learn more about it
  -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
