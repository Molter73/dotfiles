return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        watch_for_changes = true,
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, _)
                -- Never show the .git directory
                return name == '.git'
            end
        },
        keymaps = {
            ['<C-h>'] = { '<Cmd>TmuxNavigateLeft<Cr>' },
            ['<C-j>'] = { '<Cmd>TmuxNavigateDown<Cr>' },
            ['<C-k>'] = { '<Cmd>TmuxNavigateUp<Cr>' },
            ['<C-l>'] = { '<Cmd>TmuxNavigateRight<Cr>' },
            ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        },
        float = {
            max_width = 0.75,
            max_height = 0.75,
        },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
    keys = {
        {
            '-',
            function()
                require('oil').open_float(nil, {
                    preview = {},
                })
            end,
            mode = 'n',
            noremap = true,
            desc = 'Open oil.nvim in a floating window',
        },
    },
}
