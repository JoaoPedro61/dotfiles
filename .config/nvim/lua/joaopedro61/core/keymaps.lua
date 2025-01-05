local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>", vim.tbl_deep_extend("keep", opts, { desc = "Increment number" }))
keymap.set("n", "-", "<C-x>", vim.tbl_deep_extend("keep", opts, { desc = "Decrement number" }))

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', vim.tbl_deep_extend("keep", opts, { desc = "Delete a word backwards" }))

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", vim.tbl_deep_extend("keep", opts, { desc = "Select all" }))

-- Inlay hints
keymap.set("n", "<leader>i", function()
  require("joaopedro61.lsp").toggleInlayHints()
end, vim.tbl_deep_extend("keep", opts, { desc = "Toggle Inlay Hints" }))

-- New Buffer
keymap.set("n", "<leader>bn", ":tabedit<Return>", vim.tbl_deep_extend("keep", opts, { desc = "Create a new tab (buffer)" }))

-- Close current buffer
keymap.set("n", "<leader>bd", ":bd<Return>", vim.tbl_deep_extend("keep", opts, { desc = "Close buffer" }))

