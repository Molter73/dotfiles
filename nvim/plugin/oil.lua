vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/stevearc/oil.nvim',
})

require('oil').setup({
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
        ['<C-u>'] = { 'actions.preview_scroll_up' },
        ['<C-d>'] = { 'actions.preview_scroll_down' },
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
    },
    float = {
        max_width = 0.75,
        max_height = 0.75,
    },
})

vim.keymap.set('n', '-', function() require('oil').open_float(nil, { preview = {}, }) end,
    { noremap = true, desc = 'Open oil.nvim in a floating windown' })
