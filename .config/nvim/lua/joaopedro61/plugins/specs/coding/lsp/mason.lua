local ui = require("joaopedro61.ui");

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = ui.window.get_win_borders(),
        }
      })
    end
  }
}
