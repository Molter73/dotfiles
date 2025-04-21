return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            python = { 'autopep8' },
            bash = { 'shfmt' },
            sh = { 'shfmt' },
            zsh = { 'shfmt' },
        },
        format_on_save = {
            timeout_ms = 500,
        },
    },
    keys = {
        {
            '<leader>fc',
            function()
                require('conform').format({ async = false })
            end,
            mode = 'n',
            desc = 'Format buffer',
        },
    },
}
