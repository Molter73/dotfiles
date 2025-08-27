require('molter.set')
require('molter.keymaps')
require('molter.bang')

-- Autocommands
local molter = vim.api.nvim_create_augroup('MOLTER', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = molter,
    callback = require('molter.trimmers').whitespace,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = molter,
    callback = function()
        vim.keymap.set('n', '<Leader>md', '<CMD>MarkdownPreview<CR>', {
            noremap = true,
            buffer = 0,
        })
    end
})

local yank_highlight = vim.api.nvim_create_augroup('YankHighlist', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_highlight,
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
    end
})

-- Tmux breaks the cursor when leaving nvim, this brings it back up to speed
-- see: https://github.com/neovim/neovim/issues/4867#issuecomment-250911566
local cursor_reset = vim.api.nvim_create_augroup('CURSOR_RESET', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
    group = cursor_reset,
    callback = function()
        vim.cmd([[ call system('printf "\e[5 q" > $TTY') ]])
    end
})

-- Mark .Containerfile as dockerfile filetype
vim.filetype.add({
    pattern = {
        ['.*/.*%.Containerfile'] = 'dockerfile',
    }
})
