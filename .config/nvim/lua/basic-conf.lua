-- Minimal number of screen lines to keep above and below the cursor.
-- set cursor always middle
vim.opt.scrolloff = 10

vim.cmd 'set mousescroll=ver:1'

-- remove status bar
-- vim.o.cmdheight = 0
vim.opt.laststatus = 0
vim.api.nvim_set_hl(0, 'Statusline', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'StatuslineNC', { link = 'Normal' })
-- local str = string.repeat('-', vim.api.nvim_win_get_width(0))
vim.opt.statusline = ''

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'NONE', fg = '#141414' })
    vim.api.nvim_set_hl(0, 'TabLine', { bg = 'none', fg = '#141414' })
    -- vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" , fg = "#141414" })
    -- vim.api.nvim_set_hl(0, "TabLineSelect", { bg = "none" , fg = "#141414" })
  end,
})
