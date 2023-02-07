return {
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install',
        ft = 'markdown',
    },
    {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup({})
        end,
        event = 'LspAttach',
    },
    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({})
        end
    },
    {
        'fladson/vim-kitty',
        ft = 'kitty',
    },
}
