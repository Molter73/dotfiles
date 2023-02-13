local opts = {
    pickers = {
        find_files = {
            hidden = true
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
}

local keys = function()
    local builtins = require('telescope.builtin')

    return {
        { '<Leader>ff', builtins.find_files,                noremap = true, desc = '[F]ind [F]iles' },
        { '<Leader>fg', builtins.live_grep,                 noremap = true, desc = 'Live grep' },
        { '<Leader>fb', builtins.buffers,                   noremap = true, desc = '[F]ind [B]uffer' },
        { '<Leader>fs', builtins.grep_string,               noremap = true, desc = '[F]ind [S]tring' },
        { '<Leader>fh', builtins.help_tags,                 noremap = true, desc = '[F]ind [H]elp tags' },
        { '<Leader>fd', builtins.diagnostics,               noremap = true, desc = '[F]ind [D]iagnostics' },
        { '<Leader>fk', builtins.keymaps,                   noremap = true, desc = '[F]ind [K]eymaps' },
        { '<Leader>fl', builtins.current_buffer_fuzzy_find, noremap = true, desc = '[F]ind [L]ocal' },
    }
end

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
        },
        opts = opts,
        keys = keys,
        cmd = 'Telescope',
    },
}
