vim.pack.add({
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

local languages = {
	'bash',
	'fish',
	'json',
	'lua',
	'markdown',
	'markdown_inline',
	'python',
	'toml',
	'typst',
	'yaml',
}

require('nvim-treesitter').install(languages)

local ts_group = vim.api.nvim_create_augroup('user-treesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = ts_group,
	desc = 'Automatically start Treesitter highlighting',
	callback = function(args)
		local buftype = vim.bo[args.buf].buftype
		if buftype == '' then
			-- 파서가 지원되지 않는 커스텀 파일타입(예: NeogitConsole 등)에서 에러가 나지 않도록 pcall 사용
			pcall(vim.treesitter.start, args.buf)
		end
	end,
})
