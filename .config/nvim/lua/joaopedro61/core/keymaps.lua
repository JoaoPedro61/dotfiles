local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>", vim.tbl_deep_extend("keep", opts, { desc = "Increment number" }))
keymap.set("n", "-", "<C-x>", vim.tbl_deep_extend("keep", opts, { desc = "Decrement number" }))

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', vim.tbl_deep_extend("keep", opts, { desc = "Delete a word backwards" }))

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", vim.tbl_deep_extend("keep", opts, { desc = "Select all" }))

-- New Buffer
keymap.set("n", "<leader>bw", ":tabedit<Return>",
  vim.tbl_deep_extend("keep", opts, { desc = "Create a workspace (buffer)" }))

-- Close current buffer
keymap.set("n", "<leader>bd", ":bd<Return>", vim.tbl_deep_extend("keep", opts, { desc = "Close buffer" }))
