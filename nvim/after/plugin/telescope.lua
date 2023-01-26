local telescope = require('telescope')

telescope.setup({
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
})

local builtins = require('telescope.builtin')

vim.keymap.set('n', '<Leader>ff', builtins.find_files, { noremap = true, desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<Leader>fg', builtins.live_grep, { noremap = true, desc = 'Live grep' })
vim.keymap.set('n', '<Leader>fb', builtins.buffers, { noremap = true, desc = '[F]ind [B]uffer' })
vim.keymap.set('n', '<Leader>fs', builtins.grep_string, { noremap = true, desc = '[F]ind [S]tring' })
vim.keymap.set('n', '<Leader>fh', builtins.help_tags, { noremap = true, desc = '[F]ind [H]elp tags' })
vim.keymap.set('n', '<Leader>fd', builtins.diagnostics, { noremap = true, desc = '[F]ind [D]iagnostics' })
