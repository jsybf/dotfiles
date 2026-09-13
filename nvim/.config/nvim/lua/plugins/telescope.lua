vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		if ev.data.spec.name == 'telescope-fzf-native.nvim' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
			vim.system({ 'make' }, { cwd = ev.data.path }):wait()
		end
	end,
})

vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
	'https://github.com/nvim-telescope/telescope-ui-select.nvim',
	'https://github.com/jvgrootveld/telescope-zoxide',
	'https://github.com/nvim-telescope/telescope-project.nvim',
})

local telescope = require('telescope')
telescope.setup {
	pickers = {
		current_buffer_fuzzy_find = {
			theme = 'dropdown',
		},
	},
	extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
}

for _, ext in ipairs({ 'fzf', 'ui-select', 'zoxide', 'project' }) do
	pcall(telescope.load_extension, ext)
end
