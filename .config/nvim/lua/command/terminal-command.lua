-- <leader> u 를 누르면 zsh의 최근 커맨드를 현제 버퍼에 붙여넣는다.
-- 누를 때마다 그 이전 최근 커맨드를 붙여넣음
-- 3 초가 지나면 다시 최근 커맨드를 가르킨다.

local logger = require 'logging'
local hist_idx = 0
local hist = {}
local reset_timer = nil

local function imap(tbl, f)
  local t = {}
  for idx, v in ipairs(tbl) do
    t[idx] = f(v)
  end
  return t
end

local function print_table(tbl)
  for idx, v in ipairs(tbl) do
    print(v)
  end
end

local function load_shell_history(hist_size)
  local hist_path = vim.fn.expand '~/.zsh_history'
  local raw_hist = vim.fn.readfile(hist_path)

  local start_idx = math.max(1, #raw_hist - hist_size)

  local last_cmds = imap({ unpack(raw_hist, start_idx, #raw_hist) }, function(raw_line)
    return string.match(raw_line, '.*;(.+)')
  end)

  return last_cmds
end

local function paste_shell_history(hist_size, reset_time)
  print('hist_idx:' .. hist_idx)
  if #hist == 0 then
    hist = load_shell_history(hist_size)
    hist_idx = hist_size
  end

  if reset_timer then
    vim.fn.timer_stop(reset_timer)
  end
  reset_timer = vim.fn.timer_start(reset_time, function()
    hist = {}
    hist_idx = 0
  end)

  if hist_idx and 0 < hist_idx then
    local last_cmd = hist[hist_idx]
    hist_idx = hist_idx - 1
    local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, line - 1, 0, line - 1, -1, { last_cmd })
  end
end

local function get_selected_text()
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    print 'this function should be called in visual mode'
  end
  -- vim.api.nvim_input '<esc>'

  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode })
  local selected_text = table.concat(lines, '\n')
  print(selected_text)
  return selected_text
  --
  -- local _, start_l, start_c, _ = unpack(vim.fn.getpos 'v')
  -- local _, end_l, end_c, _ = unpack(vim.fn.getpos '.')
  -- print('start_pos:' .. '(' .. start_l .. ',' .. start_c .. ')' .. 'end_pos:' .. '(' .. end_l .. ',' .. end_c .. ')')
  -- local lines = vim.api.nvim_buf_get_text(0, start_l - 1, start_c - 1, end_l - 1, end_l, {})

  -- local selected_text = table.concat(lines, '\n')

  -- local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  -- local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  --
  -- print(start_pos[0])
  -- print(start_pos[1])
  -- print(end_pos[0])
  -- print(end_pos[1])
  --
  -- local lines = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, {})
  --
  -- local selected_text = table.concat(lines, '\n')
  -- return selected_text
  -- vim.cmd 'normal! gv"xy'
  -- local selected_text = vim.fn.getreg 'x'

  -- return selected_text
end

local function execute_selected_in_terminal()
  local selected_text = get_selected_text()

  -- get terminal window
  local term_buf = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value('buftype', { buf = win_buf }) == 'terminal' then
      term_buf = win_buf
      break
    end
  end

  if not term_buf then
    logger.error "can't find terminal buffer in current window"
    return
  end
  -- send and execute command
  local term_job_id = vim.bo[term_buf].channel
  vim.fn.chansend(term_job_id, selected_text .. '\n') --'\r\n')
  logger.info('executed in terminal: ' .. selected_text)
end

vim.keymap.set('v', '<leader>r', execute_selected_in_terminal, {})
vim.keymap.set('n', '<leader>u', function()
  return paste_shell_history(100, 2000)
end, { desc = 'Load previous Zsh commands one by one' })
