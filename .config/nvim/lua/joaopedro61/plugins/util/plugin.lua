local M = {}

--- Retrieves a plugin configuration from the lazy.nvim plugin manager.
---
--- @param name string: The name of the plugin to retrieve.
---
--- @return table?: The plugin configuration if found, or `nil` if the plugin doesn't exist.
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

--- Checks if a plugin is available in the lazy.nvim plugin manager.
---
--- @param plugin string: The name of the plugin to check.
---
--- @return boolean: `true` if the plugin is found, `false` otherwise.
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

--- Retrieves the options of a plugin from the lazy.nvim plugin manager.
---
--- @param name string: The name of the plugin to get options for.
---
--- @return table: The options table for the plugin, or an empty table if the plugin is not found.
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

--- Checks if a plugin has been loaded by the lazy.nvim plugin manager.
---
--- @param name string: The name of the plugin to check.
---
--- @return boolean: `true` if the plugin is loaded, `false` otherwise.
function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

--- Retrieves the file path for a package managed by Mason.
---
--- @param pkg string: The name of the package.
--- @param path string?: The specific path inside the package (optional).
--- @param opts? { warn?: boolean }: Options to control warnings. If `warn` is `true`, a warning will be shown if the package or path does not exist (default is `true`).
---
--- @return string: The full file path to the package, including the optional specific path.
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    vim.notify(
      ("Mason package not found for **%s**:\n- `%s`\nTry install or update package."):format(pkg, path),
      vim.log.levels.WARN
    )
  end
  return ret
end

return M