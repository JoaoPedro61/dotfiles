---------------------------------------------------------------------
-- ATTENTION --------------------------------------------------------
---------------------------------------------------------------------
-- To set your "mapleader" or "maplocalleader" goto the ./init.lua --
---------------------------------------------------------------------

local shell = require("joaopedro61.util.shell")
local platform = require("joaopedro61.util.platform")

local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local indent = 2

-- commom
opt.backspace = { "eol", "start", "indent" }
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"
opt.cmdheight = 0
opt.mouse = "a"
opt.number = true
opt.scrolloff = 18
opt.sidescrolloff = 3
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.wrap = false
opt.title = true
opt.inccommand = "split"
opt.formatoptions:append({ "r" })

local shell_name = shell()
if shell_name then
  opt.shell = shell_name
end

-- indention
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true
opt.smarttab = true
opt.breakindent = true

-- search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/vendor/*", "*/dist/*" })
opt.wildmenu = true
opt.path:append({ "**" })

-- ui
opt.cursorline = true
opt.laststatus = 2 -- or 3
opt.lazyredraw = true
opt.list = true

-- backups
opt.backup = false
opt.swapfile = false
opt.writebackup = false
if not platform.is_windows() then
  opt.backupskip = { "/tmp/*", "/private/tmp/*" }
end

-- autocomplete
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess = opt.shortmess + {
  c = true
}

-- perfomance
opt.history = 100
opt.redrawtime = 1500
opt.timeoutlen = 250
opt.ttimeoutlen = 10
opt.updatetime = 100

-- fold
opt.foldmethod = "marker"
opt.foldlevel = 99

-- theme
opt.termguicolors = true

-- statusline
opt.showmode = true

-- CMDS
cmd([[ filetype plugin indent on ]])
cmd([[ let &t_Cs = "\e[4:3m" ]])
cmd([[ let &t_Ce = "\e[4:0m" ]])
cmd([[ au BufNewFile,BufRead *.astro setf astro ]])
cmd([[ au BufNewFile,BufRead Podfile setf ruby ]])

-- Disable builtin plugins
local disabled_built_ins = {
  "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
  "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
  "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
  "synmenu", "optwin", "compiler", "bugreport", "ftplugin"
}
for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
