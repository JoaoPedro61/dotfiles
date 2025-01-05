return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
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
      require("which-key").add({
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
