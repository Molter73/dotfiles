local opts = {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
                features = 'all',
            },
        },
    },

    on_attach = function(client, bufnr)
        require('plugins.lsp.utils').on_attach(_, bufnr);
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
    end
}

local cwd = vim.fn.getcwd()
if string.match(cwd, 'github%.com/molter73/fact$', 1) or string.match(cwd, 'worktrees/fact/', 1) then
    opts.settings['rust-analyzer'].cargo = {
        features = {
            'bpf-test',
        },
    }
end

vim.lsp.config('rust_analyzer', opts)
vim.lsp.enable('rust_analyzer')
