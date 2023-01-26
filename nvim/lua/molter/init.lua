require('molter.set')
require('molter.keymaps')
require('molter.packer')

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
