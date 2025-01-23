--- Module for registering, resolving, and applying code formatters.

--- @overload fun(opts?: {})
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

--- @class Formatter
--- @field name string: The name of the formatter.
--- @field primary? boolean: Indicates if the formatter is the primary one. Optional.
--- @field format fun(bufnr:number) Function that applies the formatting to the buffer.
--- @field sources fun(bufnr:number):string[]: Function that returns a list of sources (strings) from the buffer.
--- @field priority number: The priority of the formatter. Formatters with higher priority are applied first.

M.formatters = {} ---@type Formatter[]: List of registered formatters.

--- Registers a formatter in the module.
--- @param formatter Formatter: The formatter to be registered.
function M.register(formatter)
  M.formatters[#M.formatters + 1] = formatter
  table.sort(M.formatters, function(a, b)
    return a.priority > b.priority
  end)
end

--- Returns the format expression. Checks if the `conform.nvim` plugin is available.
--- If available, it uses the `conform.formatexpr` function. Otherwise, it uses the Vim LSP function.
--- @return integer: The format expression.
function M.formatexpr()
  if require("joaopedro61.util.plugins").has("conform.nvim") then
    return require("conform").formatexpr()
  end
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

--- Resolves and returns a list of available formatters for the provided buffer.
--- @param buf? number: The buffer number (optional, default is the current buffer).
--- @return (Formatter|{active:boolean,resolved:string[]})[]: List of objects containing information about each formatter.
function M.resolve(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local have_primary = false
  --- @param formatter Formatter
  return vim.tbl_map(function(formatter)
    local sources = formatter.sources(buf)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false
    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, M.formatters)
end

--- Applies formatting to the current buffer or the specified buffer.
--- Attempts to format with registered formatters, respecting their priority and active state.
--- If no formatter is available or it fails, a notification is displayed.
--- @param opts? {buf?:number}: Optional settings, including the buffer number.
function M.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local done = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if formatter.active then
      done = true
      if not pcall(formatter.format, buf) then
        vim.notify("Formatter `" .. formatter.name .. "` failed", vim.log.levels.ERROR)
      end
    end
  end

  if not done then
    vim.notify("No formatter available", vim.log.levels.WARN)
  end
end

return M

