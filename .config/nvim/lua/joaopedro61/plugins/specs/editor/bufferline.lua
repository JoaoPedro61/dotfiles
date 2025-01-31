return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
    },
    version = "*",
    opts = {
      options = {
        themable = true,
        color_icons = true,
        numbers = "both",
        diagnostics = "nvim_lsp",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        indicator = {
          style = "none",
        },
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
    config = function(_, opts)
      if not pcall(require, "folke/snacks.nvim") then
        local close_command = function(n)
          Snacks.bufdelete(n)
        end

        opts.options.close_command = close_command
        opts.options.right_mouse_command = close_command
      end

      require("bufferline").setup(opts)

      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
