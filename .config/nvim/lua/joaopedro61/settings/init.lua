local json = require("joaopedro61.util.json")
local get = require("joaopedro61.util.deep_find")
local set = require("joaopedro61.util.deep_set")
local defaults = require("joaopedro61.settings.defaults")

--- @class joaopedro61.Settings.Opts.Keymaps
--- @field enable? (boolean) Enable or disable keymaps settings
--- This class represents the configuration options for keymaps settings in the overall settings.
---
--- @class joaopedro61.Settings.Opts
--- @field keymaps? (joaopedro61.Settings.Opts.Keymaps) Keymaps settings
--- This class represents the general settings options for the application, which may include keymaps settings.

local M = {}

--- The path to the settings file.
--- This variable is used to determine the location of the settings file.
M.filename = "/settings.json"

--- The full path to the settings file, including the directory and filename.
--- This path is used to load and save the settings.
M.path = vim.fn.stdpath("state") .. M.filename

--- Holds the current settings data.
--- This is initialized with default settings, which can be extended by the settings file.
M.data = defaults --- @type joaopedro61.Settings

--- Loads the settings from the settings file and extends the current settings with the loaded ones.
--- The settings are merged using the `vim.tbl_deep_extend` function.
function M.load()
  local decoded_json = json.read(M.path)
  M.data = vim.tbl_deep_extend("force", M.data, decoded_json or {})
end

--- Saves the current settings to the settings file in JSON format.
function M.save()
  json.write(M.path, M.data)
end

--- Safely retrieves a value from the settings data using the provided path.
--- If the value is not found, it returns the provided default value (`or_value`).
---
--- @param path string The path to the setting to retrieve, expressed as a dot-separated string (e.g., "keymaps.enable").
--- @param or_value any The default value to return if the setting is not found.
---
--- @return any The value from the settings at the specified path or `or_value` if the path is not found.
function M.safe_get(path, or_value)
  return get(M.data, path, or_value) or or_value
end

--- Safely sets a value in the settings data at the specified path.
--- If the setting is successfully set, it saves the updated settings to the file.
--- If the setting cannot be set, it shows an error notification.
---
--- @param path string The path to the setting to set, expressed as a dot-separated string (e.g., "keymaps.enable").
--- @param value any The value to set at the specified path in the settings.
function M.safe_set(path, value)
  local ok = set(M.data, path, value, false)
  if type(ok) ~= "nil" then
    M.save()
  else
    vim.notify("Fail to set user settings with path: " .. path, vim.log.levels.ERROR, {
      title = "Settings",
    })
  end
end

--- Default settings options for the application.
--- This includes the default keymaps settings and can be extended during setup.
local default_opts = {
  keymaps = {
    enable = true, -- By default, keymaps are enabled.
  },
}                  --- @type joaopedro61.Settings.Opts

--- Sets up the settings by loading the settings file and applying the options passed in the `opts` parameter.
--- If `opts.keymaps.enable` is `true`, the keymaps configuration is loaded.
---
--- @param opts? joaopedro61.Settings.Opts The settings options to configure the application.
--- If `opts` is provided, it overrides the default options (`default_opts`).
function M.setup(opts)
  -- Merge the default options with the user-provided options
  opts = vim.tbl_deep_extend("force", default_opts or {}, opts or {})

  -- Load the settings from the file
  M.load()

  -- If keymaps are enabled in the options, load the keymaps configuration
  if opts.keymaps.enable then
    require("joaopedro61.settings.keymaps")
  end
end

return M
