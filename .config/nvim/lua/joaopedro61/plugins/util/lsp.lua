local plugin = require("joaopedro61.plugins.util.plugin");
local lazy_util = require("lazy.core.util")
local util_format = require("joaopedro61.plugins.util.format")

local M = {}

local Keymaps = {}
local Servers = {}

M.keymaps = Keymaps
M.servers = Servers

--- A table that maps LSP method names to the corresponding clients and their supported buffers.
---
--- This table stores the LSP method names as keys, with each key mapping to another table.
--- The inner table contains a `vim.lsp.Client` object and another table that maps buffer numbers to a boolean value
--- indicating whether that buffer supports the specific LSP method.
---
--- @type table<string, table<vim.lsp.Client, table<number, boolean>>> A table where the key is the LSP method name (string),
--- and the value is a table containing the LSP client and a table of buffer numbers with boolean support status.
M._supports_method = {}

-- This code creates a table `M.action` and sets it up with a metatable.
-- The metatable defines a custom `__index` metamethod, which intercepts
-- attempts to access keys in `M.action`. When a key is accessed, it returns
-- a function that triggers a LSP (Language Server Protocol) code action.

-- The `vim.lsp.buf.code_action` function is called with the following options:
-- - `apply = true`: It applies the code action immediately.
-- - `context`: The context object, which specifies the code action details.
--     - `only`: A list containing the specific code action to apply.
--     - `diagnostics`: An empty list, indicating no diagnostics are passed in.

M.action = setmetatable({}, {
  -- The `__index` metamethod is called when an index (action) is accessed in `M.action`.
  __index = function(_, action)
    -- The returned function triggers a LSP code action for the given action name.
    return function()
      vim.lsp.buf.code_action({
        apply = true, -- Automatically apply the code action
        context = {
          only = { action }, -- Only apply the specified action
          diagnostics = {}, -- No diagnostics passed
        },
      })
    end
  end,
})

--- Retrieves a list of LSP clients based on provided filter options.
---
--- This function returns a list of active LSP clients, with the ability to filter the results based on various options such as client ID, buffer number, client name, method support, and custom filtering functions.
---
--- @param opts? lsp.Client.filter: Optional filter options to refine the list of returned LSP clients. The filter can be based on the client's ID, buffer number, name, method support, or a custom function.
--- @return vim.lsp.Client[]: A list of LSP clients that match the filter criteria.
---
--- @alias lsp.Client.filter: { id?: number, bufnr?: number, name?: string, method?: string, filter?: fun(client: lsp.Client): boolean }
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]

  -- If the new API exists, use it to get clients
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    -- Fallback to the deprecated API for older versions of Neovim
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)

    -- If a method is specified, filter clients based on whether they support that method
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end

  -- Apply the custom filter (if provided) to the list of clients
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

--- Checks if an LSP client supports specific methods for a given buffer and triggers the corresponding autocommands.
---
--- This function iterates through the methods listed in `M._supports_method` and checks if the given LSP client supports each method for the specified buffer.
--- If the client supports a method for the buffer, it registers the support and triggers an autocommand (`LspSupportsMethod`) for that method.
--- The function will not trigger on invalid, unlisted, or "nofile" buffers.
---
--- @param client vim.lsp.Client The LSP client whose supported methods are being checked.
--- @param buffer number The buffer number to check for method support.
---
--- @return nil This function does not return a value.
function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

--- Registers an autocommand that executes a function when an LSP client attaches to a buffer.
---
--- This function creates an autocommand that is triggered when the `LspAttach` event occurs.
--- The registered callback receives information about the LSP client and the buffer, then executes the provided function (`on_attach`) with these data.
--- If a `name` is provided, the function will only be triggered for the client with the matching name.
---
--- @param on_attach fun(client:vim.lsp.Client, buffer:number) The function to be called when the LSP client attaches to the buffer.
--- The `client` parameter represents the LSP client that attached, and the `buffer` parameter is the buffer number.
---
--- @param name? string (optional) If provided, the function will only trigger for the LSP client whose name matches this value.
---
--- @return integer The ID of the registered autocommand.
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

--- Registers an autocommand that executes a function whenever an "LspDynamicCapability" event is triggered.
---
--- This function creates a Vim autocommand that is triggered when the "LspDynamicCapability" event occurs.
--- The registered callback receives information about the LSP client and the buffer in which the event happened,
--- and then executes the provided function (`fn`) with these data.
---
--- @param fn fun(client:vim.lsp.Client, buffer:number):boolean? The function to be called when the event occurs.
--- The `client` parameter is an object representing the LSP client associated with the event.
--- The `buffer` parameter is the numeric identifier of the buffer where the event was triggered.
--- The function may optionally return a boolean value.
---
--- @param opts? {group?: integer} (optional) An options object that may contain a `group` field, which
--- specifies the autocommand group to be used. If not provided, the autocommand will be registered without a group.
---
--- @return integer The ID of the registered autocommand.
function M.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

--- Registers an autocommand to execute a function when a specific LSP method is supported by a client for a buffer.
---
--- This function creates an autocommand that listens for the `LspSupportsMethod` event. When the event occurs, the registered callback
--- checks if the client supports the specified LSP method for the given buffer. If so, it calls the provided function (`fn`).
---
--- The LSP method is mapped to a table (`M._supports_method`) that keeps track of which clients support the method for which buffers.
---
--- @param method string The LSP method name to track. The function will be called when the client supports this method.
---
--- @param fn fun(client:vim.lsp.Client, buffer:number) The function to be called when the LSP client supports the specified method for the buffer.
--- The `client` parameter represents the LSP client, and the `buffer` parameter is the buffer number.
---
--- @return integer The ID of the registered autocommand.
function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

--- Retrieves the default capabilities for an LSP client, extending them with additional capabilities from `cmp_nvim_lsp` (if available) and custom capabilities.
---
--- This function combines the default LSP client capabilities with additional capabilities provided by the `cmp_nvim_lsp` plugin (if it is installed),
--- and optionally with custom capabilities passed through the `with` parameter. The function returns a table containing the combined capabilities.
---
--- @param with table A table containing custom capabilities to be added to the default LSP client capabilities.
--- If not provided, an empty table is used.
---
--- @return table A table containing the default LSP client capabilities, extended with `cmp_nvim_lsp` capabilities (if available) and any custom capabilities from `with`.
function M.get_default_capabilities(with)
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    with or {}
  )

  return capabilities
end

--- Checks if a buffer is valid and meets certain conditions.
---
--- This function checks whether a buffer is valid and listed, does not have a `buftype` (indicating it's a regular buffer),
--- and its filetype is not in the `exclude` list. If all these conditions are met, the function returns `true`, otherwise `false`.
---
--- @param buffer number The buffer number to check for validity.
--- @param exclude table A table of filetypes to exclude. If the buffer's filetype is in this list, the buffer is considered invalid.
--- If not provided, an empty table is used by default.
---
--- @return boolean Returns `true` if the buffer is valid, listed, has no `buftype`, and its filetype is not in the `exclude` list; otherwise, `false`.
function M.is_valid_buf(buffer, exclude)
  if
    vim.api.nvim_buf_is_valid(buffer)
    and vim.bo[buffer].buftype == ""
    and vim.bo[buffer].buflisted
    and not vim.tbl_contains(exclude or {}, vim.bo[buffer].filetype)
  then
    return true
  end
  return false
end

--- Formats the current buffer using either LSP or Conform.
--- This function attempts to use the `conform` plugin for better formatting diffs.
--- If `conform` is not available, it falls back to using LSP formatting.
--- @param opts (lsp.Client.format?) Options for formatting. This may include any valid LSP formatting options.
--- @see vim.lsp.buf.format for LSP formatting options
function M.format(opts)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    plugin.opts("nvim-lspconfig").format or {},
    plugin.opts("conform.nvim").format or {}
  )
  local ok, conform = pcall(require, "conform")
  if ok then
    opts.formatters = {}
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

--- Creates a formatter object with options for formatting.
--- This function creates a formatter with LSP as the default formatter.
--- The resulting formatter object can be used to format buffers and get LSP client names that support formatting.
--- 
--- @param opts? (joaopedro61.Plugins.Util.Format.Formatter | { filter?: (string|lsp.Client.filter) }) Options for the formatter.
--- If a `filter` is provided, it will be used to filter the LSP clients.
--- @return (joaopedro61.Plugins.Util.Format.Formatter) The created formatter object.
--- 
--- @see M.format for the function that formats the buffer.
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter lsp.Client.filter
  ---@type joaopedro61.Plugins.Util.Format.Formatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(lazy_util.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(lazy_util.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client.supports_method("textDocument/formatting")
          or client.supports_method("textDocument/rangeFormatting")
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return lazy_util.merge(ret, opts) --[[@as joaopedro61.Plugins.Util.Format.Formatter]]
end

--- Sets up LSP handlers and registers autocommands to track dynamic capabilities and method support.
---
--- This also setup and add keymaps for the lsp clients
---
--- This function overrides the default `registerCapability` handler for LSP clients, enabling the triggering of autocommands when
--- a client registers a new capability. It also calls the `M.on_attach` and `M.on_dynamic_capability` functions to check methods
--- and dynamic capabilities when the LSP client attaches to a buffer or when dynamic capabilities are updated.
---
--- The function ensures that when a client registers a new capability, the relevant autocommands are triggered for each buffer
--- attached to the client, allowing other functions to handle the new capabilities dynamically.
---
--- @return nil This function does not return a value.
function M.setup()
  util_format.register(M.formatter())

  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end

  M.on_attach(Keymaps.on_attach)
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
  M.on_dynamic_capability(Keymaps.on_attach)
end

-------------------------------------------------------------------------------
--- Keymaps -------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Checks if a given LSP method is supported by any client for the specified buffer.
---
--- @param buffer number: The buffer number to check for LSP client support.
--- @param method string|string[]: The LSP method(s) to check. This can either be a single method (string) or a list of methods (table of strings).
---
--- @return boolean: Returns `true` if the specified method (or any of the methods, if an array is provided) is supported by any LSP client for the given buffer, otherwise returns `false`.
function Keymaps.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if Keymaps.has(buffer, m) then
        return true
      end
    end
    return false
  end

  -- Ensure the method is prefixed with "textDocument/" if not already
  method = method:find("/") and method or "textDocument/" .. method

  -- Get the LSP clients attached to the buffer
  local clients = M.get_clients({ bufnr = buffer })

  -- Check if any of the clients supports the specified method
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end

  return false
end

---@return LazyKeysLsp[]
function Keymaps.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")

  if not Keys.resolve then
    return {}
  end

  local opts = plugin.opts("nvim-lspconfig")
  local opts_keys = type(opts.keys) == "function" and opts.keys() or (opts.keys or {})
  local spec = vim.tbl_extend("force", {}, opts_keys)
  local clients = M.get_clients({ bufnr = buffer })
  if opts.servers then
    for _, client in ipairs(clients) do
      local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
      vim.list_extend(spec, maps)
    end
  end
  return Keys.resolve(spec)
end

--- Attaches key mappings to a buffer, resolving and setting them based on conditions and configurations.
---
--- This function is typically used as a callback for the `LspAttach` event to set up key mappings after LSP is attached to a buffer.
---
--- @param _ any: A placeholder parameter, usually unused in this context (typically representing the LSP client, but not used here).
--- @param buffer number: The buffer number to which the key mappings should be applied.
function Keymaps.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = Keymaps.resolve(buffer)

  -- Iterate over the resolved keymaps
  for _, keys in pairs(keymaps) do
    -- Check if the key mapping should be applied (based on "has" and "cond" conditions)
    local has = not keys.has or Keymaps.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      -- Prepare the options for setting the key mapping
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false -- Ensure the keymap is silent unless explicitly set to false
      opts.buffer = buffer

      -- Set the keymap with the resolved options
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

-------------------------------------------------------------------------------
--- Servers -------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Determines which LSP servers need to be installed, categorizing them into 'mason' and 'custom' servers.
---
--- This function checks the provided LSP server configurations to identify which servers can be handled by
--- the Mason package manager, and which require manual installation. It also takes into account whether
--- each server is enabled or disabled, and whether Mason is explicitly disabled for any given server.
---
--- @param servers lspconfig.options: A table containing LSP server configurations, where each key is a server.
---
--- @return {mason: string[], custom: string[]}: A table with two fields:
---   - `mason`: A list of LSP server names that should be handled by Mason.
---   - `custom`: A list of LSP server names that need to be manually installed (not managed by Mason).
function Servers.get_servers_to_install(servers)
  local all_mslp_servers = {}

  local have_mason, _ = pcall(require, "mason-lspconfig")
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local mason_servers = {} ---@type string[]
  local custom_servers = {} ---@type string[]

  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      if server_opts.enabled ~= false then
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          custom_servers[#custom_servers + 1] = server
        else
          mason_servers[#mason_servers + 1] = server
        end
      end
    end
  end

  return {
    mason = mason_servers,
    custom = custom_servers,
  }
end

--- Installs the specified LSP servers via Mason package manager.
---
--- This function attempts to install the list of provided servers using the Mason package manager. It allows
--- for optional setup of each server using a handler function. If the Mason package is not found or the
--- server installation fails, no action is taken. The function also merges any servers defined in the
--- `ensure_installed` option of the `mason-lspconfig` plugin configuration.
---
--- @param servers string[]: A list of LSP server names to be installed via Mason.
---   - Each string in the array represents the name of an LSP server to ensure is installed.
---
--- @param setup_handler fun(server: string): any?: An optional handler function to set up each Mason-managed LSP server.
---   - This function will be invoked for each server that is installed.
---   - The handler receives the server name as a string argument.
---
--- @return nil
---
--- Example usage:
---   local servers = {"pyright", "tsserver"}
---   Servers.install_mason_servers(servers, function(server)
---     -- custom setup logic for each server
---     print("Setting up " .. server)
---   end)
function Servers.install_mason_servers(servers, setup_handler)
  local have_mason, mlsp = pcall(require, "mason-lspconfig")

  if have_mason then
    mlsp.setup({
      ensure_installed = vim.tbl_deep_extend(
        "force",
        servers or {},
        plugin.opts("mason-lspconfig.nvim").ensure_installed or {}
      ),
      handlers = { setup_handler },
      automatic_installation = true,
    })
  end
end

return M
