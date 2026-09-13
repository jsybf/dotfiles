local yank_group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	group = yank_group,
	desc = 'Highlight when copying text',
	callback = function()
		vim.hl.on_yank()
	end,
})

local autosave_group = vim.api.nvim_create_augroup('user-autosave', { clear = true })
local autosave_timer = nil
local AUTOSAVE_INTERVAL_MS = 1000

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
	group = autosave_group,
	pattern = '*',
	desc = 'Debounced autosave',
	callback = function()
		if autosave_timer ~= nil then
			return
		end
		autosave_timer = vim.fn.timer_start(
			AUTOSAVE_INTERVAL_MS,
			function()
				if vim.bo.modified and vim.fn.expand('%') ~= '' and vim.bo.modifiable and not vim.bo.readonly then
					vim.cmd('silent! write')
				end
				autosave_timer = nil
			end
		)
	end,
})

local typst_group = vim.api.nvim_create_augroup('user-typst-preview', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
	group = typst_group,
	pattern = 'typst',
	desc = 'Start typst preview on file open',
	callback = function(args)
		-- only once for buffer
		if vim.b[args.buf].typst_preview_started then
			return
		end

		vim.b[args.buf].typst_preview_started = true
		vim.cmd('TypstPreview')
	end,
})

vim.api.nvim_create_autocmd({ 'BufUnload', 'BufDelete', 'BufWipeout' }, {
	group = typst_group,
	desc = 'Stop typst preview on buffer close',
	callback = function(args)
		if not vim.b[args.buf].typst_preview_started then
			return
		end
		vim.b[args.buf].typst_preview_started = false
		pcall(vim.api.nvim_buf_call, args.buf, function()
			vim.cmd('TypstPreviewStop')
		end)
	end,
})
