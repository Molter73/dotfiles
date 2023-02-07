return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate',
        event = 'BufReadPost',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'cpp',
                'cmake',
                'dockerfile',
                'go',
                'haskell',
                'help',
                'html',
                'json',
                'lua',
                'make',
                'python',
                'regex',
                'rust',
                'toml',
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
        event = 'BufReadPost',
        opts = {
            max_lines = 10,
        },
    }
}
