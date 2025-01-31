---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Your "mapleader" or "maplocalleader" must be defined in this -----
-- file like bellow. This prevents errors when importing the --------
-- lazy package. ----------------------------------------------------
---------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- Comment if you are using LazyVim
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Bootstrap lazy.nvim ----------------------------------------------
---------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Load the settings json to NeoVim instance ------------------------
---------------------------------------------------------------------
require("joaopedro61.settings").setup();
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- You must import the files that are not dependent on the plugins --
-- first. -----------------------------------------------------------
---------------------------------------------------------------------
-- The following files are imported by lazy.nvim, from the files:
--
-- config.autocmds (~/lua/config/autocmds.lua)
-- config.keymaps (~/lua/config/keymaps.lua)
-- config.options (~/lua/config/options.lua)
--
require("joaopedro61.autocmds")
require("joaopedro61.keymaps")
require("joaopedro61.options")
--
-- If you are not using a NeoVim framework,
-- you can simply uncomment the lines above,
-- and import this file into your root init.lua
require("joaopedro61.platform")
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ATTENTION: -------------------------------------------------------
---------------------------------------------------------------------
-- Importing lazy.nvim setup, and plugins files specs ---------------
---------------------------------------------------------------------
require("joaopedro61.plugins")
---------------------------------------------------------------------
