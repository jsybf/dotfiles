-- @param stack_depth int
local function get_func_info(stack_depth)
  local func_info = debug.getinfo(stack_depth, 'Sl')
  assert(func_info.source:sub(1, 1) == '@')

  return {
    file_path = func_info.source:sub(2),
    line = func_info.linedefined,
  }
end

local function get_date_time_info()
  local date_time = os.date '*t'
  return date_time
end

-- @param msg string
-- return string
local function build_log_msg(msg)
  -- build function info msg
  local func_info_msg = (function()
    local func_info = get_func_info(5)
    return func_info.line .. ':' .. func_info.file_path
  end)()
  -- build date time info msg
  -- ex: 2024-01-13T16:42:03
  local date_time_msg = (function()
    local date_time_info = get_date_time_info()
    return string.format(
      '%04d/%02d/%02dT%02d:%02d:%02d',
      date_time_info.year,
      date_time_info.month,
      date_time_info.day,
      date_time_info.hour,
      date_time_info.min,
      date_time_info.sec
    )
  end)()
  -- format: [time] [file path and line where function locates] msg
  return string.format('[%s] [%s] %s', date_time_msg, func_info_msg, msg)
end

local M = {}

function M.info(msg)
  local log_msg = build_log_msg(msg)
  print(log_msg)
end

return M
