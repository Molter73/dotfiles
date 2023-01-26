require('nvim-treesitter.configs').setup({
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
})

require('treesitter-context').setup({
    max_lines = 10,
})
