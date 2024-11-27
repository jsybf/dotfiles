return {
  'bluz71/vim-moonfly-colors',
  name = 'moonfly',
  lazy = false,
  priority = 1000,
  init = function()
    vim.cmd [[colorscheme moonfly]]
  end,
}
