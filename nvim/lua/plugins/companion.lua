local adapter = nil
if os.getenv('GEMINI_API_KEY') ~= nil then
    adapter = 'gemini'
elseif os.getenv('CODECOMPANION_URL') ~= nil then
    adapter = 'granite'
end

return {
    {
        'olimorris/codecompanion.nvim',
        cond = function()
            return adapter ~= nil
        end,
        lazy = true,
        dependencies = {
            { 'nvim-lua/plenary.nvim', version = false },
            'nvim-treesitter/nvim-treesitter',
            'saghen/blink.cmp',
            'franco-ruggeri/codecompanion-spinner.nvim',
        },
        opts = {
            opts = {
                log_level = 'DEBUG',
            },
            adapters = {
                granite = function()
                    if os.getenv('CODECOMPANION_URL') == nil then
                        return nil
                    end

                    return require('codecompanion.adapters').extend('openai_compatible', {
                        env = {
                            url = os.getenv('CODECOMPANION_URL'),
                        },
                    })
                end
            },
            strategies = {
                inline = {
                    adapter = adapter,
                },
                chat = {
                    adapter = adapter,
                },
                cmd = {
                    adapter = adapter,
                },
            },
            extensions = {
                spinner = {},
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
