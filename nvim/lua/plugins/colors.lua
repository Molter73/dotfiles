local opts = {
    flavour = 'mocha',
    show_end_of_buffer = true,
    transparent_background = true,
    compile = {
        enabled = true,
        path = vim.fn.stdpath('cache') .. '/catppuccin',
    },
    dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.40,
    },
    color_overrides = {
        mocha = {
            surface2 = '#686B80',
        },
    },
    styles = { -- Handles the styles of general hi groups
        comments = {},
        conditionals = {},
    },
    integrations = {
        blink_cmp = true,
        cmp = true,
        fidget = true,
        fzf = true,
        gitsigns = true,
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
        },
        telescope = true,
        treesitter = true,
        which_key = true,
    }
}

return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            local cat = require('catppuccin.palettes').get_palette('mocha')
            opts.custom_highlights = {
                LspInlayHint = { bg = 'bg' }, -- Regular background color for inlay hints
                ['@character.printf'] = { fg = cat.peach },
            }
            require('catppuccin').setup(opts)
        end,
        lazy = true,
    },
}
