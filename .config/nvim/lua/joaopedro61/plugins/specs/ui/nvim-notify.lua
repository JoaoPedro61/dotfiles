local Plugin = require("joaopedro61.plugins.util.plugin")

return {
  {
    "rcarriga/nvim-notify",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        optional = true,
      },
    },
    opts = {
      timout = 4500,
      render = "minimal",
      max_width = 50,
    },
    config = function(_, opts)
      local notify = require("notify")

      notify.setup(opts)
      vim.notify = notify

      if Plugin.has("telescope.nvim") then
        vim.keymap.set("n", "<leader>nh", ":Telescope notify<CR>", { desc = "Show notification history" })
        vim.keymap.set("n", "<leader>nc", ":NotificationClear<CR>", { desc = "Clear notification history" })
      end
    end,
  },
}
