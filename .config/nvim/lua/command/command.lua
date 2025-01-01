-- set directory of current buffer to cwd
-- can be used in netrw or normal buffer
local function set_cwd_to_buffer_dir()
  local buf_dir_path = vim.fn.expand '%:p:h'
  vim.api.nvim_set_current_dir(buf_dir_path)
end

local function run_cmd(opts)
  local command = opts.args
  -- create new buffer
  vim.cmd 'new'
  vim.bo.bufhidden = 'wipe'
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.buflisted = false -- don't show in buflist even cmd_output buffer is active

  -- execute shell command and get result
  local output = vim.fn.systemlist(command)

  -- print result of shell command to buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

local function copy_buffer_file_path_to_mac_clipboard(opts)
  -- https://neovim.io/doc/user/builtin.html
  local file_path = vim.fn.expand '%:p'
  vim.fn.system('pbcopy', file_path)
  print('Copied to clipboard: ' .. file_path)
end

vim.api.nvim_create_user_command('Wipehidden', function()
  local bufinfos = vim.fn.getbufinfo { buflisted = true }
  vim.tbl_map(function(bufinfo)
    if bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0) then
      print(('Deleting buffer %d : %s'):format(bufinfo.bufnr, bufinfo.name))
      vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = false })
    end
  end, bufinfos)
end, { desc = 'Wipeout all buffers not shown in a window' })

vim.api.nvim_create_user_command('Cwd', set_cwd_to_buffer_dir, { nargs = 0 })
vim.api.nvim_create_user_command('Rc', run_cmd, { nargs = 1 })
vim.api.nvim_create_user_command('Cp', copy_buffer_file_path_to_mac_clipboard, { nargs = 0 })
