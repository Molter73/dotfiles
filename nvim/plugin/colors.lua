vim.pack.add({ {
    src = 'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
    version = vim.version.range('*'),
} })

local cat = require('catppuccin.palettes').get_palette('mocha')
require('catppuccin').setup({
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
    custom_highlights = {
        ['@character.printf'] = { fg = cat.peach },
        ['@keyword.import.c'] = { fg = cat.mauve },
    },
    lsp_styles = {
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
    integrations = {
        blink_cmp = true,
        cmp = true,
        fzf = true,
        gitsigns = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
    }
})

vim.cmd.colorscheme('catppuccin')
