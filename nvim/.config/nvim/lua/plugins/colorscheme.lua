vim.pack.add({
    -- { src = 'https://github.com/e-q/okcolors.nvim', name = 'okcolors' },
    -- { src = 'https://github.com/junegunn/seoul256.vim' },
    -- { src = 'https://github.com/RRethy/base16-nvim'},
    -- { src = 'https://github.com/navarasu/onedark.nvim'},
    { src = 'https://github.com/wtfox/jellybeans.nvim'}
})

-- require('okcolors').setup({
--     variant = 'smooth', -- 'smooth' or 'sharp', defaults to 'smooth'
-- })
-- vim.cmd.colorscheme('okcolors')

-- vim.cmd.colorscheme('base16-flexoki-light')
-- vim.g.seoul256_light_background = 252
-- vim.cmd.colorscheme("seoul256-light")
--

-- require('onedark').setup {
--     style = 'darker',
--     -- transparent = true
-- }
-- require('onedark').load()

vim.cmd.colorscheme('jellybeans-warm')
