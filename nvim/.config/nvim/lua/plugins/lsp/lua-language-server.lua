vim.lsp.config['lua-language-server'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    ".git",
  },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
}
