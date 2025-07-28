local parsers = {
    'bash',
    'c',
    'c3',
    'cmake',
    'comment',
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'doxygen',
    'editorconfig',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'graphql',
    'helm',
    'html',
    'java',
    'javascript',
    'jinja',
    'jinja_inline',
    'jq',
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
    'rasi',
    'regex',
    'requirements',
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
