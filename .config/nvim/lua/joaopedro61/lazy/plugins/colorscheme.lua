return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      ---@param colors ColorScheme
      on_colors = function(colors)
        colors.bg = "#000000"
        colors.bg_sidebar = "#000000"
      end,
    },
  },
}
