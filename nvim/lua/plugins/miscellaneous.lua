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
        enabled = false,
    },
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left or tab" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right or tab" } },
        },
        opts = {},
    },
    {
        "hiasr/vim-zellij-navigator.nvim",
        config = function()
            require('vim-zellij-navigator').setup()
        end
    },
}
