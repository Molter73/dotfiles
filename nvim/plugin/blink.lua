vim.pack.add({
    -- optional: provides snippets for the snippet source
    'https://github.com/rafamadriz/friendly-snippets',
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range('1.*'),
    }
})

require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
    },
    completion = {
        documentation = {
            auto_show = true,
        },
    },
    fuzzy = {
        implementation = 'rust',
        prebuilt_binaries = {
            download = false,
        },
    },
})
