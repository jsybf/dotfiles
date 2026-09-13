vim.pack.add({
    'https://github.com/stevearc/aerial.nvim'
})
-- Call the setup function to change the default behavior
require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
})
