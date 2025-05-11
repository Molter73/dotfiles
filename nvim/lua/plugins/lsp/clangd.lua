local utils = require('plugins.lsp.utils')

vim.lsp.config('clangd', {
    on_attach = function(client, bufnr)
        utils.on_attach(_, bufnr)
        utils.handle_inlays(client, bufnr)
        vim.keymap.set('n', 'gh', '<cmd>ClangdSwitchSourceHeader<CR>', {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Switch between header and source files",
        })
    end,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    cmd = {
        "containerized-ls",
        utils.project_to_container(),
        "clangd",
        "--background-index",
        "--clang-tidy",
    },
})

vim.lsp.enable('clangd')
