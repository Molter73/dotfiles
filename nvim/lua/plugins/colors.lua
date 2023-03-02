local opts = {
    flavour = 'mocha',
    show_end_of_buffer = true,
    compile = {
        enabled = true,
        path = vim.fn.stdpath('cache') .. '/catppuccin',
    },
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.40,
    },
    color_overrides = {
        mocha = {
            surface2 = '#686B80',
        },
    },
    integrations = {
        cmp = true,
        telescope = true,
        gitsigns = true,
        fidget = true,
        treesitter = true,
        which_key = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { 'italic' },
                hints = { 'italic' },
                warnings = { 'italic' },
                information = { 'italic' },
            },
            underlines = {
                errors = { 'underline' },
                hints = { 'underline' },
                warnings = { 'underline' },
                information = { 'underline' },
            },
        }
    }
}

return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        opts = opts,
        lazy = true,
    },
}
