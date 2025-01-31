local M = {}

M.icons = {
  error = " ",
  warn = " ",
  info = " ",

  wrench = "",

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
