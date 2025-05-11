vim.lsp.config('basedpyright', {
    on_attach = function(_, bufnr)
        require('plugins.lsp.utils').on_attach(_, bufnr)
        vim.keymap.set('n', '<Leader>fh', '<cmd>PyrightOrganizeImports<CR>', {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Organize imports",
        })
    end
})

vim.lsp.enable('basedpyright')
