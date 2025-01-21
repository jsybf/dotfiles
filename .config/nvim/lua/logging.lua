---@class LogMetaData
---@field get_func_info function(stack_depth: number);
---@field get_date_time_info function();
local LogMetaData = {}

-- kind of interface
---@class LogWriter
---@field package write function(msg: string): nil
---@field package flush function(): nil

---@class Logger()
---@field private writer LogWriter
---@field private build_log_msg function(msg: string, level: LOGGING_LEVEL): string
---@field public info function(msg: string): nil
---@field public error function(msg: string): nil
local Logger = {}
Logger.__index = Logger

---@enum LOGGING_LEVEL
local LOGGING_LEVEL = {
  INFO = 'info',
  ERROR = 'error',
}

------------------------
--- impl LogMetaData ---
------------------------

---@param stack_depth number
function LogMetaData:get_func_info(stack_depth)
  local func_info = debug.getinfo(stack_depth, 'Sl')
  assert(func_info.source:sub(1, 1) == '@')

  return {
    file_path = func_info.source:sub(2),
    line = func_info.linedefined,
  }
end

function LogMetaData:get_date_time_info()
  local date_time = os.date '*t'
  return date_time
end

------------------------
--- impl LogMetaData ---
------------------------

-- set output resource: currently options are stdout or file
--    if opts is string                      -> write log in file with path of {opts}
--    if opts is function(msg: String): nil  -> wrap it in to @class LogWriter
--    if opts is nil                         -> write log in file with path of env(NVIM_GITP_LOG_PATH). if env not exists raise error
---@param writer_opt string | nil | function(msg: string): nil
---@return Logger
function Logger:new(writer_opt)

  -- stylua: ignore
  local if_dir = function(path) local stat = vim.uv.fs_stat(path) return (stat and stat.type == 'directory') end

  local writer = (function()
    if writer_opt == nil then
      local log_file_path = os.getenv 'NVIM_GITP_LOG_PATH'
      if log_file_path == nil then
        error 'if opts is nil in Logger:new(opts) you should set env NVIM_GITP_LOG_PATH'
      end
      return io.open(log_file_path, 'a')
    end

    if type(writer_opt) == 'string' then
      local dirname = vim.fs.dirname(writer_opt)
      print(vim.inspect(dirname))
      if not if_dir(dirname) then
        error('dir ' .. dirname .. ' does not exist')
      end
      return io.open(writer_opt, 'a')
    end

    if type(writer_opt) == 'function' then
      -- stylua: ignore
      return {
        write = function(_, msg) writer_opt(msg) end,
        flush = function(_) assert(true) end, -- need to impl and think about structure
      }
    end
  end)()

  return setmetatable({ writer = writer }, Logger)
end

---@param msg string
---@param level LOGGING_LEVEL
---@return string
function Logger:build_log_msg(msg, level)
  -- stylua: ignore
  local func_info_msg = (function() local func_info = LogMetaData:get_func_info(5) return func_info.file_path .. ':' .. func_info.line end)()
  -- format example: 2024-01-13T16:42:03
  local date_time_msg = (function()
    local date_time_info = LogMetaData:get_date_time_info()
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
  -- format:[2024-01-13T16:42:03] [file_path:function_line] [level] msg
  return string.format('[%s] [%s] [%s] %s', date_time_msg, func_info_msg, level, msg)
end

---@param msg string
function Logger:info(msg)
  local log_msg = self.build_log_msg(msg, LOGGING_LEVEL.INFO)
  self.writer:write(log_msg .. '\n')
  self.writer:flush()
end

---@param msg string
function Logger:error(msg)
  local log_msg = self.build_log_msg(msg, LOGGING_LEVEL.ERROR)
  self.writer:write(log_msg .. '\n')
  self.writer:flush()
end

return Logger
