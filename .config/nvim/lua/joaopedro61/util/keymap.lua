local status, wk = pcall(require, "which-key")

local M = {}

---Create a group to which key, does not have implementation
---to NeoVim native API
---
---@param lhs string
---@param group string
function M.group(lhs, group)
  if status then
    wk.add({ { lhs, group = group } })
  end
end

---Add key map in which-key if it exists or in a native NeoVim API
---
---Update types and need
---
---@param mode string
---@param lhs string
---@param rhs string|fun()
---@param opts? { desc: string }
---@param wk_opts?: { group: string|fun():string }
function M.set(mode, lhs, rhs, opts, wk_opts)
  if status then
    local kmap = vim.tbl_deep_extend("keep", {
      lhs,
      rhs,
      mode = mode,
    }, opts or {}, wk_opts or {})
    wk.add({ kmap })
  else
    local keymap = vim.keymap

    keymap.set(mode, lhs, rhs, opts or {})
  end
end

return M
