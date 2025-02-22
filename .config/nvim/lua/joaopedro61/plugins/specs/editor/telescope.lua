local build_cmd = require("joaopedro61.util.build_cmd")()

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
      },
      "ghassan0/telescope-glyph.nvim",
      "olacin/telescope-cc.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("glyph")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fH", builtin.highlights, { desc = "Telescope find highlights" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

      -- Find glyph/icons
      vim.keymap.set("n", "<leader>fi", "<cmd>Telescope glyph<cr>", { desc = "Telescope glyph" })

      vim.keymap.set("n", "<leader>gc", "<cmd>Telescope conventional_commits<cr>", { desc = "Conventional commit" })
    end,
  },
}
