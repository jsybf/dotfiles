local M = {}
function M.create_scretch_buf()
  local scretch_buf = vim.api.nvim_create_buf(false, false)
  vim.bo[scretch_buf].bufhidden = 'wipe'
  vim.bo[scretch_buf].buftype = 'nofile'
  vim.bo[scretch_buf].swapfile = false
  vim.bo[scretch_buf].buflisted = false

  return scretch_buf
end

function M.vertical_split(v_or_s, buf)
  if v_or_s == 'v' then
    vim.cmd 'vsplit'
  end
  vim.cmd 'vsplit'
  local win = vim.api.nvim_get_current_win()

  if buf == nil then
    return
  end

  vim.api.nvim_win_set_buf(win, buf)
  return win
end

return M
