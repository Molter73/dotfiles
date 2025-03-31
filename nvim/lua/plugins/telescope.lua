local keys = function()
    return {
        {
            '<Leader>ff',
            function()
                require('telescope.builtin').git_files({
                    show_untracked = true,
                })
            end,
            noremap = true,
            desc = '[F]ind [F]iles',
        },
        {
            '<Leader>fa',
            function()
                require('telescope.builtin').find_files()
            end,
            noremap = true,
            desc = '[F]ind [A]ll',
        },
        {
            '<Leader>fg',
            function() require('telescope.builtin').live_grep() end,
            noremap = true,
            desc = 'Live grep',
        },
        {
            '<Leader>fb',
            function() require('telescope.builtin').buffers() end,
            noremap = true,
            desc = '[F]ind [B]uffer',
        },
        {
            '<Leader>fs',
            function() require('telescope.builtin').grep_string() end,
            mode = { 'n', 'v', },
            noremap = true,
            desc = '[F]ind [S]tring',
        },
        {
            '<Leader>fh',
            function() require('telescope.builtin').help_tags() end,
            noremap = true,
            desc = '[F]ind [H]elp tags',
        },
        {
            '<Leader>fd',
            function() require('telescope.builtin').diagnostics() end,
            noremap = true,
            desc = '[F]ind [D]iagnostics',
        },
        {
            '<Leader>fk',
            function() require('telescope.builtin').keymaps() end,
            noremap = true,
            desc = '[F]ind [K]eymaps',
        },
        {
            '<Leader>fl',
            function() require('telescope.builtin').current_buffer_fuzzy_find() end,
            noremap = true,
            desc = '[F]ind [L]ocal',
        },
        {
            '<Leader>ft',
            function() require('telescope.builtin').resume() end,
            noremap = true,
            desc = 'Resume Telescope search',
        },
    }
end

local build =
'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = build,
            },
        },
        config = function()
            require('telescope').setup({
                pickers = {
                    find_files = {
                        hidden = true
                    },
                    buffers = {
                        sort_mru = true,
                        mappings = {
                            i = {
                                ['<C-s>'] = require('telescope.actions').delete_buffer,
                            },
                        },
                    },
                },
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--hidden",
                        "--smart-case"
                    },
                    file_ignore_patterns = {
                        "^.git/"
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
        end,
        keys = keys,
        cmd = 'Telescope',
    },
}
