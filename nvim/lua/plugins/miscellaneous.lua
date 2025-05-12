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
            require('fidget').setup({
                progress = {
                    display = {
                        progress_icon = { "bouncing_ball" },
                    },
                },
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            })
        end,
    },
    {
        'christoomey/vim-tmux-navigator',
    },
}
