vim.api.nvim_create_autocmd({
    'BufReadPre',
    'BufNewFile',
    'InsertLeave',
    'BufWritePost'
}, {
    callback = function(_)
        require('lint').try_lint()
    end
})

vim.pack.add({
    'https://github.com/mfussenegger/nvim-lint',
})

require('lint').linters_by_ft = {
    --python = { 'flake8' },
    dockerfile = { 'hadolint' },
}
