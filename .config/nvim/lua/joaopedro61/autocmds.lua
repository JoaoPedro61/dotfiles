local autocmd = vim.api.nvim_create_autocmd

-- Disable the concealing in some file formats
-- The default conceallevel is 3
autocmd("FileType", {
  pattern = { "json", "jsonc", "maskdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Set colorcolumn
autocmd("Filetype", {
  pattern = { "python", "rst", "rust", "c", "cpp" },
  command = "set colorcolumn=80",
})

-- Set wrap to this files types
autocmd("Filetype", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("BufWritePre", {
  callback = function()
    local settings = require("joaopedro61.settings")
    if settings.safe_get("auto_format.enable", false) then
      local exclude = settings.safe_get("auto_format.exclude", {})
      if not vim.tbl_contains(exclude, vim.bo.filetype) then
        require("joaopedro61.plugins.util.format")()
      end
    end
  end,
})
