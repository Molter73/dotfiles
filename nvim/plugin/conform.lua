vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        require('conform').setup({
            formatters_by_ft = {
                --python = { 'autopep8' },
                bash = { 'shfmt' },
                sh = { 'shfmt' },
                zsh = { 'shfmt' },
            },
            format_on_save = {
                timeout_ms = 500,
            },
        })
    end
})

vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
})

vim.keymap.set('n', '<leader>fc', function()
    require('conform').format({ async = false })
end, {
    desc = 'Format buffer',
})
