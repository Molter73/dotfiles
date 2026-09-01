vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/ibhagwan/fzf-lua',
})

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
    grep = {
        rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --iglob '!.git/' -e"
    },
    keymap = {
        builtin = {
            ['<C-d>'] = 'preview-half-page-down',
            ['<C-u>'] = 'preview-half-page-up',
        },
        fzf = {
            ['ctrl-q'] = 'select-all+accept',
        },
    },
})
require('fzf-lua').register_ui_select()

vim.keymap.set('n', '<Leader>ff', function()
        require('fzf-lua').git_files({
            show_untracked = true,
        })
    end,
    {
        noremap = true,
        desc = '[F]ind [F]iles',
    }
)

vim.keymap.set('n', '<Leader>fa', function() require('fzf-lua').files() end, {
    noremap = true,
    desc = '[F]ind [A]ll',
})

vim.keymap.set('n', '<Leader>fg', function() require('fzf-lua').live_grep() end, {
    noremap = true,
    desc = 'Live grep',
})

vim.keymap.set('n', '<Leader>fb', function() require('fzf-lua').buffers() end, {
    noremap = true,
    desc = '[F]ind [B]uffer',
})

vim.keymap.set({ 'n', 'v' }, '<Leader>fs', function() require('fzf-lua').grep_cword() end, {
    noremap = true,
    desc = '[F]ind [S]tring',
})

vim.keymap.set('n', '<Leader>fh', function() require('fzf-lua').helptags() end, {
    noremap = true,
    desc = '[F]ind [H]elp tags',
})

vim.keymap.set('n', '<Leader>fd', function() require('fzf-lua').diagnostics_document() end, {
    noremap = true,
    desc = '[F]ind [D]iagnostics',
})

vim.keymap.set('n', '<Leader>fk', function() require('fzf-lua').keymaps() end, {
    noremap = true,
    desc = '[F]ind [K]eymaps',
})

vim.keymap.set('n', '<Leader>fl', function() require('fzf-lua').grep_curbuf() end, {
    noremap = true,
    desc = '[F]ind [L]ocal',
})

vim.keymap.set('n', '<Leader>ft', function() require('fzf-lua').resume() end, {
    noremap = true,
    desc = 'Resume fzf-lua search',
})

vim.keymap.set('n', '<Leader>fm', function() require('fzf-lua').manpages() end, {
    noremap = true,
    desc = 'Search manpages',
})

vim.keymap.set('n', '<Leader>fp', function() require('fzf-lua').spell_suggest() end, {
    noremap = true,
    desc = 'Spelling suggestions',
})
