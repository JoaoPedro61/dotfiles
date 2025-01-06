return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      -- You can add your custom keys like billow. Ex:
      -- {
      --   "<leader>?",
      --   function()
      --     require("which-key").show({ global = false })
      --   end,
      --   desc = "Buffer Local Keymaps (which-key)",
      -- },
    },
    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "modern"
      })

      wk.add({
        { "<leader>f", group = "file" },
        {
          "<leader>b",
          group = "buffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "<leader>c", group = "code" },
        { "<leader>u", group = "ui" },
      });
    end
  }
}
