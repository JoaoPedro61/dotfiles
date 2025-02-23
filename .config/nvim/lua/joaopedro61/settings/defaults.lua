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
--- @class joaopedro61.Settings.Lsp.Diagnostics
--- A table representing LSP Diagnostics settings
--- @field enable? (boolean) Optional setting to enable or disable diagnostics in LSP
---
--- @class joaopedro61.Settings.Lsp
--- A table representing LSP settings.
--- @field inlay_hint? (joaopedro61.Settings.Lsp.InlayHints) Optional setting to enable or disable inlay hints in LSP.
--- @field codelens? (joaopedro61.Settings.Lsp.Codelens) Optional setting to enable or disable codelens in LSP.
--- @field diagnostics? (joaopedro61.Settings.Lsp.Diagnostics) Optional setting to enable os disable diagnostics in LSP.
---
--- @class joaopedro61.Settings.AutoFormat
--- A table representing AutoFormat settings.
--- @field enable? (boolean) Optional setting to enable or disable auto format in LSP.
--- @field exclude? (string[]) Optional string array to disable auto format in some file types
---
--- @class joaopedro61.Settings.Colorscheme
--- A table representing Colorscheme settings.
--- @field name? (string) The colorscheme name
--- @field variant? (string) The colorscheme variant. Ex.: transparent
---
--- @class joaopedro61.Settings
--- A table representing the user settings.
--- @field colorscheme? (joaopedro61.Settings.Colorscheme) Optional settings for colorscheme settings.
--- @field auto_format? (joaopedro61.Settings.AutoFormat) Optional setting for auto-formatting behavior (default is false).
--- @field lsp? (joaopedro61.Settings.Lsp) Optional LSP settings (default is empty).

local default_settings = {
  colorscheme = {
    name = "sonokai",
    variant = "transparent",
  },
  auto_format = {
    enable = false,
    exclude = {},
  },
  lsp = {
    inlay_hint = {
      enable = true,
      exclude = {},
    },
    codelens = {
      enable = true,
      exclude = {},
    },
    diagnostics = {
      enable = true,
    },
  },
} --- @type joaopedro61.Settings

return default_settings
