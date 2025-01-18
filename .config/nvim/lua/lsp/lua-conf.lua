return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- workspace = {
      --   library = {
      --     ['~/.local/share/nvim/lazy'] = true,
      --   },
      -- },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
      diagnostics = {
        disable = {
          'unused',
          'unused-function',
          'code-after-break',
          'empty-block',
          'redundant-return',
          'trailing-space',
          'unreachable-code',
          'unused-label',
          'unused-local',
          'unused-varag',
          'missing-parameters',
          'missing-fields',
        },
      },
    },
  },
  -- cmd = {...},
  -- filetypes = { ...},
  -- capabilities = {},
}
