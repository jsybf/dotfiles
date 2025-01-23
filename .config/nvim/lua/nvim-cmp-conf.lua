local function tab_select_next_mapping(fallback)
  local cmp = require 'cmp'
  if cmp.visible() then
    -- tab누를 때 첫 추천결과를 건너뛰고 2번째 부터 선택되는거 해결
    if cmp.get_selected_index() == 1 and not cmp.get_active_entry() then
      cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
    else
      cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
    end
  else
    fallback()
  end
end

local function setup_cmp_cmdline()
  local cmp = require 'cmp'
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' },
        },
      },
    }),
  })
end

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {},
    },
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    setup_cmp_cmdline()

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      performance = { max_view_entries = 10 },
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = {
        ['<Tab>'] = cmp.mapping(tab_select_next_mapping, { 'i' }),
        -- ['<C-Space>'] = cmp.mapping.complete {},
      },

      sources = {
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    }
  end,
}
