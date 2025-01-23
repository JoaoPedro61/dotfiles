local ui = require("joaopedro61.ui")
local lsp = require("joaopedro61.util.plugins.coding.lsp")

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
      ui = {
        border = ui.window.get_win_borders(),
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      keys = {
        { "<leader>cL", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        {
          "gd",
          vim.lsp.buf.definition,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          vim.lsp.buf.references,
          desc = "References",
          nowait = true,
        },
        { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        {
          "K",
          function()
            return vim.lsp.buf.hover()
          end,
          desc = "Hover",
        },
        {
          "gK",
          function()
            return vim.lsp.buf.signature_help()
          end,
          desc = "Signature Help",
          has = "signatureHelp",
        },
        {
          "<c-k>",
          function()
            return vim.lsp.buf.signature_help()
          end,
          mode = "i",
          desc = "Signature Help",
          has = "signatureHelp",
        },
        {
          "<leader>ca",
          vim.lsp.buf.code_action,
          desc = "Code Action",
          mode = { "n", "v" },
          has = "codeAction",
        },
        {
          "<leader>cl",
          vim.lsp.codelens.run,
          desc = "Run Codelens",
          mode = { "n", "v" },
          has = "codeLens",
        },
        {
          "<leader>cC",
          vim.lsp.codelens.refresh,
          desc = "Refresh & Display Codelens",
          mode = { "n" },
          has = "codeLens",
        },
        {
          "<leader>cR",
          function()
            Snacks.rename.rename_file()
          end,
          desc = "Rename File",
          mode = { "n" },
          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
        },
        {
          "<leader>cr",
          vim.lsp.buf.rename,
          desc = "Rename",
          has = "rename",
        },
        {
          "<leader>cA",
          lsp.action.source,
          desc = "Source Action",
          has = "codeAction",
        },
        {
          "]]",
          function()
            Snacks.words.jump(vim.v.count1)
          end,
          has = "documentHighlight",
          desc = "Next Reference",
          cond = function()
            return Snacks.words.is_enabled()
          end,
        },
        {
          "[[",
          function()
            Snacks.words.jump(-vim.v.count1)
          end,
          has = "documentHighlight",
          desc = "Prev Reference",
          cond = function()
            return Snacks.words.is_enabled()
          end,
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = {
          "vue",
        },
      },
      codelens = {
        enabled = true,
        exclude = {
          "vue",
        },
      },
      capabilities = {
        workspace = {
          fileoperations = {
            didrename = true,
            willrename = true,
          },
        },
      },
      --- You need add lsp clients names here, this clients will be automatic installed
      --- via mason, or a custom handler in "setups" property.
      ---
      --- Example:
      --- {
      ---   servers = {
      ---     angularls = {}
      ---   }
      --- }
      ---
      --- @type lspconfig.options
      servers = {},
      --- You can add a custom setup handler here
      ---
      --- Example:
      --- {
      ---   servers = {
      ---     angularls = {},
      ---   },
      ---   setups = {
      ---     angularls = function(server_name, server_opts)
      ---       vim.print(server_opts)
      ---     end
      ---   }
      --- }
      --- @type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setups = {},
    },

    config = function(_, opts)
      lsp.setup()

      if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
        lsp.on_supports_method("textdocument/inlayhint", function(_, buffer)
          if lsp.is_valid_buf(buffer, opts.inlay_hints.exclude) then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      if opts.codelens.enabled and vim.lsp.codelens then
        lsp.on_supports_method("textdocument/codelens", function(_, buffer)
          if lsp.is_valid_buf(buffer, opts.codelens.exclude) then
            vim.lsp.codelens.refresh()
          end
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = function()
              if lsp.is_valid_buf(buffer, opts.codelens.exclude) then
                vim.lsp.codelens.refresh()
              end
            end,
          })
        end)
      end

      local servers = opts.servers or {}
      local setups = opts.setups or {}
      local capabilities = lsp.get_default_capabilities(opts.capabilities)
      local servers_installer = lsp.Servers.get_servers_to_install(servers)
      local multi_instance_control = {} --- @type string[]

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if setups[server] then
          if setups[server](server, server_opts) then
            return
          end
        elseif setups["*"] then
          if setups["*"](server, server_opts) then
            return
          end
        end
        if not vim.tbl_contains(multi_instance_control, server) then
          multi_instance_control[#multi_instance_control + 1] = server
          require("lspconfig")[server].setup(server_opts)
        end
      end

      if servers_installer.mason then
        lsp.Servers.install_mason_servers(servers_installer.mason, setup)
      end

      if servers_installer.custom then
        for _, server_name in ipairs(servers_installer.custom) do
          setup(server_name)
        end
      end
    end,
  },
}
