return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufReadPost',
        version = false,
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'cmake',
                'cpp',
                'css',
                'dockerfile',
                'go',
                'html',
                'java',
                'javascript',
                'json',
                'latex',
                'lua',
                'make',
                'ocaml',
                'proto',
                'python',
                'php',
                'regex',
                'ruby', -- For Vagrantfile
                'rust',
                'sql',
                'toml',
                'vim',
                'vimdoc',
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
