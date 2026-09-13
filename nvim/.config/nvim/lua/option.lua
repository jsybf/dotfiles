-- leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader= ' '

-- basic settings
vim.opt.number = true
vim.opt.mouse = 'a'

-- sync clipboard between neovim and OS
vim.opt.clipboard:append('unnamedplus')

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- tab options
vim.opt.breakindent = true
vim.opt.tabstop = 4        -- set acutal length of tab
vim.opt.shiftwidth = 4     -- ???
vim.opt.softtabstop = 4    -- set length of tab during editing
vim.opt.expandtab = true   -- substitute tab to spaces
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- resource files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- colors
vim.opt.termguicolors = true

-- fonts
vim.opt.ambiwidth = "single" -- set east asian ambiguous width, special char twice the width of ASCII char


