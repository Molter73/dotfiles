local utils = require('plugins.lsp.utils')

vim.lsp.config('clangd', {
    on_attach = function(client, bufnr)
        utils.on_attach(_, bufnr)
        utils.handle_inlays(client, bufnr)

        vim.api.nvim_buf_create_user_command(bufnr, 'ClangdSwitchSourceHeader', function()
            client:request('textDocument/switchSourceHeader', {
                uri = vim.uri_from_bufnr(bufnr),
            }, function(_, uri)
                if not uri or uri == '' then
                    vim.api.nvim_echo({ 'Correspoding file cannot be determinde' }, false, {})
                    return
                end

                vim.api.nvim_cmd({
                    cmd = 'edit',
                    args = { vim.uri_to_fname(uri) },
                }, {})
            end, bufnr)
        end, {})

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
