return {
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install',
    },

    {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup({})
        end,
    },

    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({})
        end
    },

    'fladson/vim-kitty',
}
