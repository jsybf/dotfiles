return {
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    require('oil').setup {
      view_options = {

        show_hidden = true,

        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, '.')
        end,

        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return name == '..' or name == '.git'
        end,
      }, -- view_options end
    }
  end,
}
