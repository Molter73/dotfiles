return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        git = {
            files = {
                cmd = 'git ls-files --exclude-standard --others --cached',
            },
        },
    },
    keys = {
        {
            '<Leader>ff',
            function()
                require('fzf-lua').git_files({
                    show_untracked = true,
                })
            end,
            noremap = true,
            desc = '[F]ind [F]iles',
        },
        {
            '<Leader>fa',
            function()
                require('fzf-lua').files()
            end,
            noremap = true,
            desc = '[F]ind [A]ll',
        },
        {
            '<Leader>fg',
            function() require('fzf-lua').live_grep() end,
            noremap = true,
            desc = 'Live grep',
        },
        {
            '<Leader>fb',
            function() require('fzf-lua').buffers() end,
            noremap = true,
            desc = '[F]ind [B]uffer',
        },
        {
            '<Leader>fs',
            function() require('fzf-lua').grep_cword() end,
            mode = { 'n', 'v', },
            noremap = true,
            desc = '[F]ind [S]tring',
        },
        {
            '<Leader>fh',
            function() require('fzf-lua').helptags() end,
            noremap = true,
            desc = '[F]ind [H]elp tags',
        },
        {
            '<Leader>fd',
            function() require('fzf-lua').diagnostics_document() end,
            noremap = true,
            desc = '[F]ind [D]iagnostics',
        },
        {
            '<Leader>fk',
            function() require('fzf-lua').keymaps() end,
            noremap = true,
            desc = '[F]ind [K]eymaps',
        },
        {
            '<Leader>fl',
            function() require('fzf-lua').grep_curbuf() end,
            noremap = true,
            desc = '[F]ind [L]ocal',
        },
        {
            '<Leader>ft',
            function() require('fzf-lua').resume() end,
            noremap = true,
            desc = 'Resume Telescope search',
        },
    },
}
