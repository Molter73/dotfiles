return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile', 'InsertLeave' },
    config = function()
        require('lint').linters_by_ft = {
            python = { 'flake8' },
            dockerfile = { 'hadolint' },
        }

        -- Setup autocommand
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
    end,
}
