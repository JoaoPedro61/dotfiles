local has_words_before = require("joaopedro61.util.has_words_before")

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",

      -- enable snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Used to add parentheses on select a method or function
      -- in autocomplete menu
      "windwp/nvim-autopairs",

      -- add pictograms to the completion popup
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require('lspkind')

      local window_style = cmp.config.window.bordered({
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = "Normal:MENU,FloatBorder:BORDER,CursorLine:SELECT,Search:MENU",
      });

      cmp.setup({
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
          end
        end,

        formatting = {
          format = lspkind.cmp_format(),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = window_style,
          documentation = window_style,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),

        mapping = {
          ["<C-j>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.visible_docs() then
                cmp.scroll_docs(4)
              else
                fallback()
              end
            end,
          }),
          ["<C-k>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.visible_docs() then
                cmp.scroll_docs(-4)
              else
                fallback()
              end
            end,
          }),

          -- Safety select entries with "<CR>" (Enter)
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                if luasnip.expandable() then
                  luasnip.expand()
                else
                  -- Check which of these options is the best:
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                  -- cmp.confirm({
                  --   select = true,
                  -- })
                end
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
          }),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if #cmp.get_entries() == 1 then
                cmp.confirm({ select = true })
              else
                cmp.select_next_item()
              end
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            elseif has_words_before() then
              cmp.complete()
              if #cmp.get_entries() == 1 then
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        enabled = function()
          -- Set of commands where cmp will be disabled
          local disabled = {
            IncRename = true
          }
          -- Get first word of cmdline
          local cmd = vim.fn.getcmdline():match("%S+")
          -- Return true if cmd isn't disabled
          -- else call/return cmp.close(), which returns false
          return not disabled[cmd] or cmp.close()
        end,
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })

      local autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on(
        "confirm_done",
        autopairs.on_confirm_done()
      )
    end
  }
}
