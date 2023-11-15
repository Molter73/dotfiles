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
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require('which-key').setup({})
        end
    },
    {
        'fladson/vim-kitty',
        ft = 'kitty',
    },
    {
        'christoomey/vim-tmux-navigator',
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {
            restriction_mode = "hint",
        }
    },
}
