return {
    {
        "ravitemer/mcphub.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",
        lazy = true,
        config = function()
            require("mcphub").setup()
        end
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim",
        },
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
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        show_result_in_chat = true, -- Show mcp tool results in chat
                        make_vars = true,           -- Convert resources to #variables
                        make_slash_commands = true, -- Add prompts as /slash commands
                    },
                },
            },
        },
        cmd = {
            'CodeCompanion',
            'CodeCompanionActions',
            'CodeCompanionChat',
        },
        keys = {
            { '<Leader>aa', '<cmd>CodeCompanionActions<cr>' },
            { '<Leader>ac', '<cmd>CodeCompanionChat<cr>' },
        },
    },
}
