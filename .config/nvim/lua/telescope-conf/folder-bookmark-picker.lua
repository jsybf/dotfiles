local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local logger = require('logging'):new(nil)

---@param msg string
local function log_info_wrap(msg)
  -- stylua: ignore
  return function() logger:info(msg) end
end

local M = {}

---@alias folder_bookmark {name: string, path: string, visit_count: number}

local folder_bookmark_file_path = '/Users/gitp/dotfiles/.config/nvim/data/folder-bookmark.json'

---@return folder_bookmark[]
local function load_bookmark_file()
  -- stylua: ignore
  local if_dir = function(path) local stat = vim.uv.fs_stat(path) return (stat and stat.type == 'directory') end

  local file = assert(io.open(folder_bookmark_file_path, 'r'), log_info_wrap('failed to open bookmark_file path:' .. folder_bookmark_file_path))
  local file_content = file:read '*a'
  file:close()
  local bookmark_data = vim.fn.json_decode(file_content)

  for _, data in ipairs(bookmark_data) do
    assert(data['name'] and data['path'] and data['visit_count'], log_info_wrap 'bookmark_file assert failed')
    assert(type(data['name']) == 'string', log_info_wrap 'bookmark_file assert failed')
    assert(type(data['path']) == 'string', log_info_wrap 'bookmark_file assert failed')
    assert(type(data['visit_count']) == 'number', log_info_wrap 'bookmark_file assert failed')
    assert(if_dir(data['path']), log_info_wrap 'bookmark_file assert failed')
  end

  return bookmark_data
end

---@param bookmark_name string
local function update_bookmark_count(bookmark_name)
  ---@type folder_bookmark[]
  local bookmarks = load_bookmark_file()

  local update_count = 1
  for _, bookmark in ipairs(bookmarks) do
    if bookmark.name == bookmark_name then
      bookmark.visit_count = bookmark.visit_count + 1
    end
  end
  assert(update_count == 1)

  local file = assert(io.open(folder_bookmark_file_path, 'w'), log_info_wrap('failed to open bookmark_file path:' .. folder_bookmark_file_path))
  print(vim.inspect(bookmarks))
  file:write(vim.fn.json_encode(bookmarks))
  file:close()
end

local function get_folder_bookmark_picker(opts)
  local finder = finders.new_table {
    ---@type folder_bookmark[]
    results = load_bookmark_file(),
    ---@param entry folder_bookmark
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry.name .. ' -> ' .. entry.path,
        ordinal = entry.name,
      }
    end,
  }

  local mappings = function(prompt_bufnr, map)
    local select_action = function()
      -- boilerplate
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()

      update_bookmark_count(selection.value.name)

      local prev_cwd = vim.fn.chdir(selection.value.path)
      logger:info('changed cwd from ' .. prev_cwd .. ' to ' .. selection.value.path)
    end

    actions.select_default:replace(select_action)
    return true
  end

  opts = opts or {}
  local picker = pickers.new(opts, {
    prompt_title = 'folder bookmark',
    finder = finder,
    sorter = conf.generic_sorter(opts),
    attach_mappings = mappings,
  })

  return picker
end

function M:folder_bookmark_picker(opts)
  get_folder_bookmark_picker(opts):find()
end

return M
