return {
  'RRethy/base16-nvim',
  name = 'base16-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- vim.cmd [[colorscheme base16-black-metal]]
    require('base16-colorscheme').setup {
      base00 = '#000000',
      base01 = '#121212',
      base02 = '#222222',
      base03 = '#828282', -- comment color
      base04 = '#999999',
      base05 = '#e0e0e0', -- main text color
      base06 = '#999999',
      base07 = '#c1c1c1',
      base08 = '#5f8787',
      base09 = '#aaaaaa',
      base0A = '#e78a53',
      base0B = '#fbcb97',
      base0C = '#aaaaaa',
      base0D = '#888888',
      base0E = '#999999',
      base0F = '#444444',
    }
  end,
}
