return {
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install',
        ft = 'markdown',
    },
    {
        'j-hui/fidget.nvim',
        event = 'VeryLazy',
        config = function()
            require('fidget').setup({})
        end,
    },
    {
        'christoomey/vim-tmux-navigator',
    },
}
