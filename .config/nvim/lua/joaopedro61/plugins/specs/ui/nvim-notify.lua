return {
  {
    "rcarriga/nvim-notify",
    opts = {
      timout = 4500,
      render = "minimal",
      max_width = 50,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify

      -- TODO:
      -- require('telescope').extensions.notify.notify(<opts>)
    end,
  },
}
