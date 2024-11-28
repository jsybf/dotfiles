-- Minimal number of screen lines to keep above and below the cursor.
-- set cursor always middle
vim.opt.scrolloff = 999

-- window split line color config
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'NONE', fg = '#141414' })
    vim.api.nvim_set_hl(0, 'TabLine', { bg = 'none', fg = '#141414' })
    -- vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" , fg = "#141414" })
    -- vim.api.nvim_set_hl(0, "TabLineSelect", { bg = "none" , fg = "#141414" })
  end,
})
