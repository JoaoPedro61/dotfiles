local build_cmd = require("joaopedro61.util.build_cmd")()

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
          dotfiles = false,
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false
        },
        view = {
          adaptive_size = false,
          side = "left",
          width = 30,
          preserve_window_proportions = true
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
            enable = true
          },
        },
        actions = {
          change_dir = {
            -- this disable change cwd to parent folder
            restrict_above_cwd = true,
          },
          open_file = {
            resize_window = true
          }
        }
      })

      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Toggle file explorer" }))
      keymap.set("n", "<leader>fE", ":NvimTreeFindFile<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Open file explorer (Focus in file)" }))
      keymap.set("n", "<leader>fo", ":NvimTreeFocus<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Focus on file explorer" }))
      keymap.set("n", "<leader>fc", ":NvimTreeCollapse<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Collapse all folders in explorer" }))
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
            or
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
      }
    },
    config = function()
      require("telescope").setup()
      pcall(require("telescope").load_extension, "fzf")

      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fH', builtin.highlights, { desc = 'Telescope find highlights' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  }
}
