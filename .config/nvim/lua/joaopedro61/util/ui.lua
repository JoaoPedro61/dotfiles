local M = {}

-- for more icons see: https://github.com/2KAbhishek/nerdy.nvim/blob/main/lua/nerdy/icons.lua
M.icons = {
  error = " ",
  warn = " ",
  info = " ",

  dot = "",

  wrench = "",

  tab = "",

  git = {
    branch = "",
    diff = {
      added = " ",
      modified = "󰝤 ",
      removed = " ",
    },
  },
}

function M.get_win_borders()
  return { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
end

function M.get_win_highlight()
  return "Normal:MENU,FloatBorder:BORDER,Search:None,CursorLine:PmenuSel"
end

function M.get_win_highlight_docs()
  return "Normal:MENU,FloatBorder:BORDER,CursorLine:SELECT,Search:MENU"
end

return M
