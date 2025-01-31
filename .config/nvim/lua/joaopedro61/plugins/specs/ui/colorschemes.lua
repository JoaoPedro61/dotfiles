return {
  -- {
  --   "zaldih/themery.nvim",
  --   priority = 1000,
  --   dependencies = {
  --     "folke/tokyonight.nvim",
  --     {
  --       'b0o/lavi.nvim',
  --       dependencies = { 'rktjmp/lush.nvim' },
  --     },
  --     {
  --       "xiyaowong/transparent.nvim",
  --       config = function()
  --         require('transparent').setup({
  --           -- Use the telescope highlights, to find panels highlights
  --           extra_groups = {
  --             -- Native Float Popups Panels
  --             "NormalFloat",
  --             "VertSplit",
  --             "Pmenu",
  --             "FloatBorder",

  --             -- NvimTree Plugin Panels
  --             "NvimTreeWinSeparator",
  --             "NvimTreeNormal",
  --             "NvimTreeNormalNC",

  --             -- Telescope Plugin Panels
  --             "TelescopeNormal",
  --             "TelescopeBorder",
  --             "TelescopePromptTitle",
  --             "TelescopePromptBorder",

  --             -- WhichKey Plugin Panels
  --             "WhichKeyNormal",
  --             "WhichKeyTitle",

  --             -- Bufferline Plugin Panels
  --             "BufferLineOffsetSeparator"
  --           },
  --         })

  --         if pcall(require, "lualine") then
  --           require('transparent').clear_prefix('lualine')
  --         end

  --         if pcall(require, "bufferline") then
  --           require('transparent').clear_prefix('bufferLine')
  --         end
  --       end
  --     }
  --   },
  --   config = function()
  --     local themery = require("themery")
  --     local defaultTheme = "Default Dark"

  --     themery.setup({
  --       themes = {
  --         {
  --           name = "Default Dark",
  --           colorscheme = "default",
  --           before = [[
  --             vim.opt.background = "dark"
  --           ]],
  --         },
  --         {
  --           name = "Default Light",
  --           colorscheme = "default",
  --           before = [[
  --             vim.opt.background = "light"
  --           ]],
  --         },
  --         {
  --           name = "Tokyonight Day",
  --           colorscheme = "tokyonight-day",
  --           before = [[
  --             vim.opt.background = "light"
  --           ]],
  --         },
  --         {
  --           name = "Tokyonight Night",
  --           colorscheme = "tokyonight-night",
  --           before = [[
  --             vim.opt.background = "dark"
  --           ]],
  --         },
  --         {
  --           name = "Lavi",
  --           colorscheme = "lavi",
  --           before = [[
  --             vim.opt.background = "dark"
  --           ]],
  --         },
  --       },
  --       livePreview = true,
  --     })

  --     local keymap = vim.keymap;

  --     keymap.set("n", "<leader>ut", ":Themery<CR>", { desc = "Open theme picker" })
  --     keymap.set("n", "<leader>uT", ":TransparentToggle<CR>", { desc = "Toggle transparent mode" })

  --     if pcall(themery.getCurrentTheme) and themery.getCurrentTheme() == nil then
  --       themery.setThemeByName(defaultTheme, true)
  --     end
  --   end
  -- }
}
