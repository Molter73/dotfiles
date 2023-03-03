return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufReadPost',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'cmake',
                'cpp',
                'css',
                'dockerfile',
                'go',
                'help',
                'html',
                'java',
                'json',
                'lua',
                'make',
                'python',
                'regex',
                'rust',
                'toml',
                'vim',
                'yaml',
            },

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            max_lines = 10,
        },
    }
}
