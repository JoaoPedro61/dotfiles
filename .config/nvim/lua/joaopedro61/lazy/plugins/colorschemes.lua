return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      "folke/tokyonight.nvim",
      {
        'b0o/lavi.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
      },
      {
        "xiyaowong/transparent.nvim",
        config = function()
          require('transparent').setup({
            -- Use the telescope highlights, to find panels highlights
            extra_groups = {
              -- Native Float Popups Panels
              "NormalFloat",
              "VertSplit",
              "Pmenu",
              "FloatBorder",

              -- NvimTree Plugin Panels
              "NvimTreeWinSeparator",
              "NvimTreeNormal",
              "NvimTreeNormalNC",

              -- Telescope Plugin Panels
              "TelescopeNormal",
              "TelescopeBorder",
              "TelescopePromptTitle",
              "TelescopePromptBorder",

              -- WhichKey Plugin Panels
              "WhichKeyNormal",
              "WhichKeyTitle",
            },
          })

          if pcall(require, "lualine") then
            require('transparent').clear_prefix('lualine')
          end
          -- require('transparent').clear_prefix('BufferLine')
        end
      }
    },
    config = function()
      local themery = require("themery")
      local defaultTheme = "Night"

      themery.setup({
        themes = {
          {
            name = "Day",
            colorscheme = "tokyonight-day",
            before = [[
              vim.opt.background = "light"
            ]],
          },
          {
            name = "Night",
            colorscheme = "tokyonight-night",
            before = [[
              vim.opt.background = "dark"
            ]],
          },
          {
            name = "Default",
            colorscheme = "default",
            before = [[
              vim.opt.background = "dark"
            ]],
          }
        },
        livePreview = true,
      })

      local keymap = vim.keymap;

      keymap.set("n", "<leader>ut", ":Themery<CR>", { desc = "Open theme picker" })
      keymap.set("n", "<leader>uT", ":TransparentToggle<CR>", { desc = "Toggle transparent mode" })

      if pcall(themery.getCurrentTheme) and themery.getCurrentTheme() == nil then
        themery.setThemeByName(defaultTheme, true)
      end
    end
  }
}
