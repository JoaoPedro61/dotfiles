local json = require("joaopedro61.util.json");

--- @class joaopedro61.Settings.Lsp.InlayHints
--- A table representing LSP InlayHints settings.
--- @field enable? (boolean) Optional setting to enable or disable inlay hints in LSP.
--- @field exclude? (string[]) Optional string array to disable inlay hints in some file types
--- 
--- @class joaopedro61.Settings.Lsp.Codelens
--- A table representing LSP Codelens settings.
--- @field enable? (boolean) Optional setting to enable or disable codelens in LSP.
--- @field exclude? (string[]) Optional string array to disable codelens in some file types
--- 
--- @class joaopedro61.Settings.Lsp
--- A table representing LSP settings.
--- @field inlay_hints? (joaopedro61.Settings.Lsp.InlayHints) Optional setting to enable or disable inlay hints in LSP.
--- @field codelens? (joaopedro61.Settings.Lsp.Codelens) Optional setting to enable or disable codelens in LSP.
--- 
--- @class joaopedro61.Settings.AutoFormat
--- A table representing AutoFormat settings.
--- @field enable? (boolean) Optional setting to enable or disable auto format in LSP.
--- @field exclude? (string[]) Optional string array to disable auto format in some file types
--- 
--- @class joaopedro61.Settings
--- A table representing the user settings.
--- @field colorscheme? (string) Optional setting for the colorscheme (default is "default").
--- @field transparent? (boolean) Optional setting for transparency (default is false).
--- @field auto_format? (joaopedro61.Settings.AutoFormat) Optional setting for auto-formatting behavior (default is false).
--- @field lsp? (joaopedro61.Settings.Lsp) Optional LSP settings (default is empty).

local M = {}

M.filename = "/settings.json"

M.path = vim.fn.stdpath("state") .. M.filename;

M.data = {
  auto_format = {
    enable = false,
    exclude = {}
  },
  colorscheme = "default",
  lsp = {
    inlay_hints = {
      enable = true,
      exclude = {}
    },
    codelens = {
      enable = true,
      exclude = {}
    },
  }
} --- @type joaopedro61.Settings

function M.load()
  local decoded_json = json.read(M.path)
  M.data = vim.tbl_deep_extend("force", M.data, decoded_json or {})
end

function M.save()
  json.write(M.path, M.data)
end

function M.setup()
  M.load();
end

--- @param fn fun(settings: joaopedro61.Settings): nil Execute this function and perform save settings on next
function M.save_after_run(fn)
  fn(M.data)
  M.save();
end

setmetatable(M, {
  __index = function(t, key)
    return t.data[key]
  end,
})

return M;
