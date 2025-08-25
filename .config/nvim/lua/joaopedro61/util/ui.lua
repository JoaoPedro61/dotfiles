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

  ia = {
    copilot = "",
  },
}

M.colors = {
  fg = {
    dark = "#bbc2cf",
    light = "#27273b",
  },
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

function M.colors.foreground(based_opts)
  local fg = M.colors.fg[vim.opt.background:get() or "dark"]
  return vim.tbl_deep_extend("keep", { fg = fg }, based_opts or {})
end

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
