vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

})

require('nvim-tree').setup {
        filters = {
                git_ignored = false
        },
        sync_root_with_cwd = true,
        git = { enable = false},
}
