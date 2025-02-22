return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- See configs: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L380
      require("nvim-tree").setup({
        filters = {
          enable = false,
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          adaptive_size = false,
          side = "left",
          width = 20,
          preserve_window_proportions = false,
        },
        diagnostics = {
          enable = true,
        },
        modified = {
          enable = true,
        },
        git = {
          enable = true,
        },
        log = {
          enable = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        renderer = {
          hidden_display = "simple",
          -- this disable cwd title to parent folder
          root_folder_label = false,

          indent_markers = {
            enable = true,
          },
        },
        actions = {
          change_dir = {
            -- this disable change cwd to parent folder
            restrict_above_cwd = true,
          },
          open_file = {
            resize_window = false,
          },
        },
      })

      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      keymap.set(
        "n",
        "<leader>e",
        ":NvimTreeToggle<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Toogle explorer" })
      )
      keymap.set(
        "n",
        "<leader>ee",
        ":NvimTreeToggle<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Toogle explorer" })
      )
      keymap.set(
        "n",
        "<leader>ef",
        ":NvimTreeFocus<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Reveal in explorer" })
      )
      keymap.set(
        "n",
        "<leader>ec",
        ":NvimTreeFocus<CR> :NvimTreeCollapse<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Collapse all folders in explorer" })
      )
    end,
  },
}
