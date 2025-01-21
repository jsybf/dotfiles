local logger = require('logging'):new(nil)
local function search_symbol(args)
  local query = args['fargs'][1] or ''

  local workspace_dirs = vim.lsp.buf.list_workspace_folders()
  logger:info('searched workspace_dir: ' .. vim.inspect(workspace_dirs))
  logger:info('searching_query: ' .. query)

  vim.lsp.buf.workspace_symbol(query)
end

-- local function hover()
--
-- end

vim.api.nvim_create_user_command('Lssw', search_symbol, { nargs = '?', desc = 'lsp search symbols in workspace' })
