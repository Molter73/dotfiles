local parsers = {
    'bash',
    'c',
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
    'sway',
    'toml',
    'vim',
    'vimdoc',
    'yaml',
    'zig',
    'zsh',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = parsers,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
    end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    callback = function()
        require('treesitter-context').setup({ max_lines = 10 })
    end
})

vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
})

require('nvim-treesitter').install(parsers)
