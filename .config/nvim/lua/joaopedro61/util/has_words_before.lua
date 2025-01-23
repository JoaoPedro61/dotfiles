--- Checks if there are non-whitespace characters before the cursor in the current line.
--- This function checks if the cursor is not at the beginning of the line and if the character before the cursor is not a whitespace character.
--- It returns `true` if there are non-whitespace characters before the cursor, and `false` otherwise.
---
--- @return boolean: `true` if there are non-whitespace characters before the cursor, `false` otherwise.
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(1))
  return col ~= 1 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return has_words_before

