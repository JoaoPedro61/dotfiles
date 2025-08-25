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
  pattern = { "python", "rst", "rust", "c", "cpp", "typescript" },
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

autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.diagnostic.is_enabled() then
      for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
          return
        end
      end
      vim.diagnostic.open_float({
        scope = "cursor",
        focusable = false,
        close_events = {
          "CursorMoved",
          "CursorMovedI",
          "BufHidden",
          "InsertCharPre",
          "WinLeave",
        },
      })
    end
  end,
})
