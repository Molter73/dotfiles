vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = 'clippy',
            },
        },
    },
    on_attach = function(client, bufnr)
        require('plugins.lsp.utils').on_attach(_, bufnr);
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
    end
})

vim.lsp.enable('rust_analyzer')
