return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "modern"
      })

      wk.add({
        { "<leader>f",     group = "file" },
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
        { "<leader>c",     group = "code" },
        { "<leader>u",     group = "ui" },
        { "<leader><tab>", group = "tabpage" },
        { "<leader>p",     group = "plugins" },
      });
    end
  }
}
