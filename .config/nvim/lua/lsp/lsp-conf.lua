local logger = require('logging'):new(nil)

local function lsp_key_maps(event)
  -- helper function
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  local telescope_builtin = require 'telescope.builtin'

  -- default keymap
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('<C-p>', vim.lsp.buf.signature_help, 'lsp signature_help', 'i') -- jet brains style key-mapping
  map('<C-Space>', vim.lsp.buf.hover, 'lsp signature_help', { 'n', 'i' }) -- jet brains style key-mapping

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client == nil then
    logger:error 'client must not be null'
    return
  end

  -- if lsp supports highlight
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references })

    -- when detached
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  -- if lsp supports inlay hint
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    -- stylua: ignore
    map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
  end
end

-- ensure dependencies are installed
local function ensure_installed(servers, capabilities)
  require('mason').setup()

  -- add additional tools
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, { 'stylua' })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    handlers = {
      -- apply config from servers table
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

local function setup_lsp_diags()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
  })
end

return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants. Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
    'hrsh7th/cmp-nvim-lsp', -- Allows extra capabilities provided by nvim-cmp
  },

  config = function()
    -- add lsp capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- list lsp
    local servers = {
      pyright = require 'lsp.python-conf',
      yamlls = require 'lsp.yaml-conf',
      lua_ls = require 'lsp.lua-conf',
      bashls = require 'lsp.bash-conf', -- bash lsp
      shfmt = {}, -- bash formatter
      shellcheck = {}, -- bash linter
    }
    ensure_installed(servers, capabilities)
    -- when lsp is attached
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        assert(client)
        logger:info('lsp attached name:' .. client.name)
        logger:info('lsp attached capabilities:' .. vim.inspect(client.server_capabilities))

        lsp_key_maps(event) -- set lsp keymap
      end,
    })

    -- more configs
    setup_lsp_diags()
    require 'lsp.command'
  end,
}
