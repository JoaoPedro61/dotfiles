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
          custom = { "node_modules", "\\.cache", ".git/", "dist/" },
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
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
        view = {
          float = {
            -- This enable float view
            enable = false,
          }
        },
        renderer = {
          hidden_display = "simple",
        }
      })

      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Toggle file explorer" }))
      keymap.set("n", "<leader>fE", ":NvimTreeFindFile<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Open file explorer (Focus file)" }))
      keymap.set("n", "<leader>fc", ":NvimTreeCollapse<CR>",
        vim.tbl_deep_extend("keep", opts, { desc = "Collapse all folders in explorer" }))
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin  = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  }
}
