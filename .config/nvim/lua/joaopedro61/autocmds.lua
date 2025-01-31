local autocmd = vim.api.nvim_create_autocmd
local createcmd = vim.api.nvim_create_user_command;

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

autocmd("BufWritePre", {
  callback = function (event)
    local settings = require("joaopedro61.settings");
    if settings.auto_format.enable then
      if not vim.tbl_contains(settings.auto_format.exclude, vim.bo.filetype) then
        require("joaopedro61.plugins.util.format")()
      end
    end
  end
})

createcmd("SaveUserSettings", function()
  require("joaopedro61.settings").save();
end, { desc = "Save user settings" })
