-- WARN: This is a build for installation (and also update) step, so it must come before adding the plugins in order to get triggered.
vim.api.nvim_create_autocmd('PackChanged', {
	desc = ' telescope: build extensions and setup it up in order',
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
			vim.system({ 'make' }, { cwd = ev.data.path })
		end
	end,
})

vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
	'https://github.com/nvim-telescope/telescope-ui-select.nvim',
	'https://github.com/jvgrootveld/telescope-zoxide',
    'https://github.com/nvim-telescope/telescope-project.nvim'
})

require('telescope').setup {
    pickers = {
        current_buffer_fuzzy_find = {
            theme = 'dropdown',
        }
    },
	extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require("telescope").load_extension('zoxide')
require('telescope').load_extension('project')
