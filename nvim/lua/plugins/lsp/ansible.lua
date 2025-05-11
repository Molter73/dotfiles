vim.lsp.config('ansiblels', {
    on_attach = function(_, bufnr)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
            {
                noremap = true,
                silent = true,
                buffer = bufnr,
                desc = 'Hover information'
            })
    end,
})

vim.lsp.enable('ansiblels')
