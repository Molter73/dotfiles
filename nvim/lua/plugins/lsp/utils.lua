local M = {}

M.on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>fr', vim.lsp.buf.format, opts)
end


M.project_to_container = function()
    local nvim_lsp = require 'lspconfig'
    local root_pattern = nvim_lsp.util.root_pattern('.git')

    -- Turn the name of the current file into the name of an expected container, assuming that
    -- the container running/building this file is named the same as the basename of the project
    -- that the file is in
    --
    -- The name of the current buffer
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Turned into a filename
    local filename = nvim_lsp.util.path.is_absolute(bufname) and bufname or
        nvim_lsp.util.path.join(vim.loop.cwd(), bufname)

    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or nvim_lsp.util.path.dirname(filename)

    -- And finally perform what is essentially a `basename` on this directory
    return vim.fn.fnamemodify(nvim_lsp.util.find_git_ancestor(project_dirname), ':t')
end
return M
