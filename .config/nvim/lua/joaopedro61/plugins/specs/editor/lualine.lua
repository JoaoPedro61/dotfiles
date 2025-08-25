local ui = require("joaopedro61.util.ui")

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "arkav/lualine-lsp-progress",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      extensions = {
        "lazy",
        "mason",
        "symbols-outline",
        "fzf",
        {
          sections = {},
          filetypes = { "NvimTree" },
        },
      },
      disabled_filetypes = { "Lazy", "NvimTree" },
      filetypes = { "NvimTree" },
      always_show_tabline = false,

      ---------------------------------------------------------------------------------------------------------------------
      -- See configuration reference: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua --
      ---------------------------------------------------------------------------------------------------------------------
      options = {
        component_separators = "",
        section_separators = "",
        theme = "iceberg",
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      ---------------------------------------------------------------------------------------------------------------------
      ---------------------------------------------------------------------------------------------------------------------
    },
    config = function(_, opts)
      local lualine = require("lualine")

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      local colors = ui.colors

      local with_fg_based = function(based_opts)
        return ui.colors.foreground(based_opts)
      end

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(opts.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(opts.sections.lualine_x, component)
      end

      -------------------------------------------------------------------------
      --- Left lualine component ----------------------------------------------
      -------------------------------------------------------------------------
      ins_left({
        "mode",
        color = function()
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1, left = 1 },
      })

      ins_left({
        "filesize",
        cond = conditions.buffer_not_empty,
        color = with_fg_based({ gui = "bold" }),
      })

      ins_left({
        "filename",
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = "bold" },
      })

      ins_left({
        "location",
        color = with_fg_based({ gui = "bold" }),
      })

      ins_left({
        "progress",
        color = with_fg_based({ gui = "bold" }),
      })

      ins_left({
        "diagnostics",
        symbols = {
          error = ui.icons.error,
          warn = ui.icons.warn,
          info = ui.icons.info,
        },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
      })

      ins_left({
        function()
          local inactive = "Inactive"
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return inactive
          end
          local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          local clients_names = "" --- @type string
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              clients_names = clients_names .. " " .. ui.icons.dot .. " " .. client.name
            end
          end
          if #clients_names then
            return clients_names
          end
          return inactive
        end,
        icon = ui.icons.wrench .. " LSP:",
        color = with_fg_based({ gui = "bold" }),
      })
      -------------------------------------------------------------------------
      -------------------------------------------------------------------------

      -------------------------------------------------------------------------
      --- Left lualine component ----------------------------------------------
      -------------------------------------------------------------------------
      ins_right({
        function()
          return vim.opt.tabstop:get() .. ""
        end,
        icon = ui.icons.tab,
        color = with_fg_based({ gui = "bold" }),
      })

      ins_right({
        "lsp_progress",
        display_components = { "lsp_client_name", "spinner" },
        colors = {
          percentage = colors.cyan,
          title = colors.cyan,
          message = colors.cyan,
          spinner = colors.cyan,
          lsp_client_name = colors.magenta,
          use = true,
        },
        cond = conditions.hide_in_width,
        color = with_fg_based({ gui = "bold" }),
      })

      ins_right({
        "o:encoding",
        fmt = string.upper,
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
      })

      ins_right({
        "fileformat",
        fmt = string.upper,
        icons_enabled = false,
        color = { fg = colors.green, gui = "bold" },
      })

      ins_right({
        "branch",
        icon = ui.icons.git.branch,
        color = { fg = colors.violet, gui = "bold" },
      })

      ins_right({
        "diff",
        symbols = {
          added = ui.icons.git.diff.added,
          modified = ui.icons.git.diff.modified,
          removed = ui.icons.git.diff.removed,
        },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      })
      -------------------------------------------------------------------------
      -------------------------------------------------------------------------

      lualine.setup(opts)
    end,
  },
}
