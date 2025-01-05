if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("joaopedro61.util.debug").dump(...)
end
vim.print = _G.dd

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Your "mapleader" or "maplocalleader" must be defined in this -----
-- file like bellow. This prevents errors when importing the --------
-- lazy package. ----------------------------------------------------
---------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Requirements to use the package "nvim-tree/nvim-tree.lua", this --
-- should be defined before load lazy package. This prevents to -----
-- directory list at start nvim with "nvim ." -----------------------
---------------------------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- You must import the lazy package first, and then import ----------
-- the core package. ------------------------------------------------
---------------------------------------------------------------------
require("joaopedro61.lazy")
require("joaopedro61.core")
--------------------------------------------------------------------
