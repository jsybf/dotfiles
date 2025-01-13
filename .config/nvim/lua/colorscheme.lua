return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = 'none',
          },
        },
      },
    },
  },
  init = function()
    vim.cmd.colorscheme 'kanagawa-wave'
  end,
}

-- return {
--   'bluz71/vim-moonfly-colors',
--   name = 'moonfly',
--   lazy = false,
--   priority = 1000,
--   init = function()
--     vim.cmd [[colorscheme moonfly]]
--   end,
-- }
