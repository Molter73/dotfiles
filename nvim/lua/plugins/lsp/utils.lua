local M = {}

M.on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local set_keymap = function(mode, lhs, rhs, desc, opts)
        local full_opts = opts
        full_opts['desc'] = desc

        vim.keymap.set(mode, lhs, rhs, full_opts)
    end

    local format = function()
        vim.lsp.buf.format({
            formatting_options = {
                trimTrailingWhitespace = true,
                insertFinalNewline = true,
                trimFinalNewlines = true,
            },
        })
    end

    set_keymap('n', 'K', vim.lsp.buf.hover, 'Hover information', opts)
    set_keymap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', opts)
    set_keymap('n', 'gd', vim.lsp.buf.definition, 'Go to definition', opts)
    set_keymap('n', 'gr', require('telescope.builtin').lsp_references, 'Go to reference', opts)
    set_keymap('n', '<Leader>gi', vim.lsp.buf.implementation, 'Go to implementation', opts)
    set_keymap('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature help', opts)
    set_keymap('n', '<Leader>D', vim.lsp.buf.type_definition, 'Go to type definition', opts)
    set_keymap('n', '<Leader>rn', vim.lsp.buf.rename, 'Rename symbol under cursor', opts)
    set_keymap('n', '<Leader>ca', vim.lsp.buf.code_action, 'Code Action', opts)
    set_keymap('n', '<Leader>fr', format, 'Format buffer', opts)
end


M.project_to_container = function()
    local nvim_lsp = require('lspconfig')
    local root_pattern = nvim_lsp.util.root_pattern('.git')

    local cwd = root_pattern(vim.fn.getcwd())

    -- If cwd is a repo, it takes precedence as the container name.
    if cwd ~= '' then
        return vim.fn.fnamemodify(cwd, ':t')
    end

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
