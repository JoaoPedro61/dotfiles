local M = {};

M.disabled_builtin = {
  "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
  "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
  "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
  "synmenu", "optwin", "compiler", "bugreport", "ftplugin"
}

function M.disable_builtin()
  for _, plugin in pairs(M.disabled_builtin) do
    vim.g["loaded_" .. plugin] = 1
  end
end

setmetatable(M, {
  __call = function (m, ...)
    m.disable_builtin(...)
  end
})

return M;
