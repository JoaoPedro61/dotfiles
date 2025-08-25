local ui = require("joaopedro61.util.ui")
local lsp = require("joaopedro61.plugins.util.lsp")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return ui.icons.ia.copilot
        end,
        cond = function()
          return package.loaded["copilot"] and require("copilot.api").status.data ~= nil
        end,
        color = function()
          local clients = package.loaded["copilot"] and lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          if #clients > 0 then
            local api = require("copilot.api")
            local status = api.status.data.status

            if status == "InProgress" then
              return { fg = ui.colors.blue, gui = "bold" }
            elseif status == "Warning" then
              return { fg = ui.colors.yellow, gui = "bold" }
            elseif status == "Error" then
              return { fg = ui.colors.red, gui = "bold" }
            end

            return ui.colors.foreground({ gui = "bold" })
          end
        end,
      })
    end,
  },
}
