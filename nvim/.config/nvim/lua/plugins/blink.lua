vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
})

require('blink.cmp').setup{
    signature = { enabled = true },
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback", },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback", },
    },
    completion = {
        list = {
            selection = {
                preselect = false,   -- 처음엔 아무것도 선택 안 됨
                auto_insert = true,  -- 이동하는 항목을 버퍼에 바로 삽입
            },
        },
        ghost_text = { enabled = true },
    },
    cmdline = {
        completion = {
            menu =  { auto_show = true },
            list = {
                selection = {
                    preselect = false,   -- 처음엔 아무것도 선택 안 됨
                    auto_insert = true,  -- 이동하는 항목을 버퍼에 바로 삽입
                }
            },
        }
    }
}

