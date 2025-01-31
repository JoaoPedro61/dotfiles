return {
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {},
    opts = function()
      --- @type any
      local close_command = 'bdelete! %d'
      if not pcall(require, "folke/snacks.nvim") then
        -- this will close the current buffer and focus and another buffer opened
        -- this fixes the problem on close buffer and focus on nvim-tree
        close_command = function(n)
          Snacks.bufdelete(n)
        end
      end

      return {
        options = {
          themable = true,
          color_icons = true,
          numbers = "both",
          diagnostics = "nvim_lsp",
          close_command = close_command,
          right_mouse_command = close_command,
          indicator = {
            style = "none",
          },
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true
            }
          }
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)

      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end
  }
}