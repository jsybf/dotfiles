-- set smooth scroll delay?? 자연스러운 동작을 위해선 낮은 값 설정
vim.g.neovide_scroll_animation_length = 0.06
-- enabled when giving --no-vsync option
vim.g.neovide_refresh_rate = 100
-- how much finger should be moved to be interpreted as scroll guesture
vim.g.neovide_touch_deadzone = 1.0
-- disable cursor animation
vim.g.neovide_cursor_animation_length = 0

---@param delta number
local function change_scale_factor(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

-- stylua: ignore
vim.keymap.set('n', '<C-=>', function() change_scale_factor(1.1) end)
-- stylua: ignore
vim.keymap.set('n', '<C-->', function() change_scale_factor(1/1.1) end)

-- enable cmd+c and cmd+v in neovide
-- https://github.com/neovide/neovide/issues/1263
vim.g.neovide_input_use_logo = 1
vim.keymap.set('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.keymap.set('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.keymap.set('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set('t', '<D-v>', function() local clipboard = vim.fn.getreg('+') vim.api.nvim_feedkeys(clipboard, 't', true) end, { noremap = true, silent = true })
