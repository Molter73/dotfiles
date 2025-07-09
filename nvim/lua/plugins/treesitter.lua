vim.filetype.add({
    extension = {
        c3 = 'c3',
        c3i = 'c3',
        c3t = 'c3',
    },
})

local parsers = {
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
}

local langs = parsers
table.insert(langs, 'yaml.github')
table.insert(langs, 'codecompanion')

vim.api.nvim_create_autocmd('FileType', {
    pattern = langs,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
    end,
})

return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        version = false,
        lazy = false,
        branch = 'main',
        config = function(_, _)
            require('nvim-treesitter').install(parsers)
            require('nvim-treesitter.parsers').c3 = {
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
