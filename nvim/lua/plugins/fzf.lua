return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('fzf-lua').setup({
            git = {
                files = {
                    cmd = 'git ls-files --exclude-standard --others --cached',
                },
            },
            winopts = {
                height = 0.75,
                width = 0.75,
            },
        })
        require('fzf-lua').register_ui_select()
    end,
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
        {
            '<Leader>fm',
            function() require('fzf-lua').manpages() end,
            noremap = true,
            desc = 'Search manpages',
        },
        {
            '<Leader>fp',
            function() require('fzf-lua').spell_suggest() end,
            noremap = true,
            desc = 'Spelling sugestions',
        },
    },
}
