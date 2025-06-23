vim.filetype.add({
    extension = {
        c3 = 'c3',
        c3i = 'c3',
        c3t = 'c3',
    },
})

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
                'comment',
                'cpp',
                'css',
                'dockerfile',
                'doxygen',
                'editorconfig',
                'git_rebase',
                'gitignore',
                'go',
                'graphql',
                'helm',
                'html',
                'java',
                'javascript',
                'json',
                'jsonc',
                'just',
                'latex',
                'lua',
                'make',
                'markdown',
                'markdown_inline',
                'ocaml',
                'php',
                'printf',
                'proto',
                'python',
                'regex',
                'ruby', -- For Vagrantfile
                'rust',
                'sql',
                'tmux',
                'toml',
                'vim',
                'vimdoc',
                'yaml',
                'zig',
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
            local parsers_config = require('nvim-treesitter.parsers').get_parser_configs()
            parsers_config.c3 = {
                install_info = {
                    url = 'https://github.com/c3lang/tree-sitter-c3',
                    files = { 'src/parser.c', 'src/scanner.c' },
                    branch = 'main',
                }
            }
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
