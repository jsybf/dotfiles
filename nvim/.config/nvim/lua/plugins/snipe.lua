vim.pack.add({
'https://github.com/leath-dub/snipe.nvim'
})

require("snipe").setup({
    ui = {
        position = "center",
        open_win_override = {
            border = "rounded", -- use "rounded" for rounded border
        },
    }
})
