local autocmd = vim.api.nvim_create_autocmd

-- Turn off paste mode when leaving insert
autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
autocmd("FileType", {
  pattern = { "json", "jsonc", "maskdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Set colorcolumn
autocmd("Filetype", {
  pattern = { "python", "rst", "rust", "c", "cpp" },
  command = "set colorcolumn=80"
})

-- Set wrap to this files types
autocmd("Filetype", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end
})

-- This is a temporary autocmd
autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end
})
