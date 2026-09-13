local wipe_hidden = require('my.wipe-hidden')

vim.api.nvim_create_user_command(
	'Wh',
	wipe_hidden.wipe_hidden_buf,
	{ nargs = 0 }
)
