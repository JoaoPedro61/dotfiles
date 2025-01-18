local merge = require("joaopedro61.util.merge_tables")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local comment_opts = { desc = "Toggle comment", silent = true, remap = true }
local buffers_opts = { silent = true, remap = true }

-- Reload Config
map("n", "<leader>r", function()
  require("joaopedro61.util.reload_config")()
end, merge(opts, { desc = "Reload configuration" }))

-- Increment/decrement
map("n", "+", "<C-a>", merge(opts, { desc = "Increment number" }))
map("n", "-", "<C-x>", merge(opts, { desc = "Decrement number" }))

-- Delete a word backwards
map("n", "dw", 'vb"_d', merge(opts, { desc = "Delete a word backwards" }))

-- Select all
map("n", "<C-a>", "gg<S-v>G", merge(opts, { desc = "Select all" }))

-- Tabs (tabpages)
map("n", "<leader><tab>l", "<cmd>tablast<cr>", merge(opts, { desc = "Last Tab" }))
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", merge(opts, { desc = "Close Other Tabs" }))
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", merge(opts, { desc = "First Tab" }))
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", merge(opts, { desc = "New Tab" }))
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", merge(opts, { desc = "Next Tab" }))
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", merge(opts, { desc = "Close Tab" }))
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", merge(opts, { desc = "Previous Tab" }))

-- Close current buffer
map("n", "<leader>bd", ":bd<Return>", merge(buffers_opts, { desc = "Close buffer" }))

-- Comments
map("n", "<leader>cc", "gcc", comment_opts)
map("v", "<leader>cc", "gc", comment_opts)
