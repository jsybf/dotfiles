-- (ref) https://github.com/astral-sh/ty/issues/2616

vim.lsp.config['ty'] = {
    cmd = { "ty", "server" },
    filetypes = { 'python' },
  -- settings = {
  --   ty = {
  --   }
  -- }
}
