return {
    "olimorris/codecompanion.nvim",
    cond = function(_)
        return os.getenv('CODECOMPANION_URL') ~= nil
    end,
    opts = {
        adapters = {
            granite = function()
                return require('codecompanion.adapters').extend('openai_compatible', {
                    env = {
                        url = os.getenv('CODECOMPANION_URL'),
                    },
                })
            end
        },
        strategies = {
            inline = {
                adapter = 'granite',
            },
            chat = {
                adapter = 'granite',
            },
        },
    },
    cmd = {
        'CodeCompanion',
        'CodeCompanionActions',
        'CodeCompanionChat',
    },
    keys = {
        { '<Leader>ac', '<cmd>CodeCompanionActions<cr>' },
    },
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
