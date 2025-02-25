local settings = require("joaopedro61.settings");
local merge = require("joaopedro61.util.merge")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }


map("n", "<leader>Ss", function()
  settings.save()
end, merge(opts, { desc = "Save user settings" }))

-- Auto format settings
map("n", "<leader>Sf", "", merge(opts, { desc = "auto_format" }))

map("n", "<leader>Sfe", function()
  settings.safe_set(
    "auto_format.enable",
    not settings.safe_get("auto_format.enable", false)
  )
end, merge(opts, { desc = "Toggle auto format" }))

map("n", "<leader>Ss", function ()
  vim.print(
    require("joaopedro61.settings").data
  )
end, merge(opts, { desc = "Show current settings" }))

-- LSP settings
-- Add more keymapings bellow
