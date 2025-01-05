return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        theme = "auto",
        extensions = {
          "lazy",
          "mason",
          "nvim-tree",
          "symbols-outline"
        }
      })
    end
  }
}
