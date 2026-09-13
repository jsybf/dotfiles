local M = {}

function M.wipe_hidden_buf()
  vim.iter(vim.api.nvim_list_bufs())
  :map(function(buf_id)
    return {
      id = buf_id,
      buftype = vim.api.nvim_get_option_value('buftype', { buf = buf_id }),
      modified = vim.api.nvim_get_option_value('modified', { buf = buf_id }),
      if_hidden = vim.fn.getbufinfo(buf_id)[1].hidden,
      loaded = vim.api.nvim_buf_is_loaded(buf_id)
    }
  end)
  :filter(function (buf_info) return buf_info.if_hidden == 1 and buf_info.loaded == true and buf_info.buftype == '' and buf_info.modified == false end)
  :each(function(buf_info)
    vim.api.nvim_buf_delete(buf_info.id, {force = false, unload = false})
    end
  )
end

return M
