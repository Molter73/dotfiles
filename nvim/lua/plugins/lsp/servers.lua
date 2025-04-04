local M = {}

local utils = require('plugins.lsp.utils')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.lua_ls = function()
    require('lspconfig').lua_ls.setup {
        on_attach = utils.on_attach,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

M.yamlls = function()
    require('lspconfig').yamlls.setup({
        settings = {
            yaml = {
                schemas = {
                    ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                }
            }
        }
    })
end

M.clangd = function()
    require('lspconfig').clangd.setup({
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
end

M.cmake = function()
    require('lspconfig').neocmake.setup({
        capabilities = capabilities,
    })
end

M.golang = function()
    require('lspconfig').gopls.setup({
        settings = {
            gopls = {
                buildFlags = { "-tags=linux" },
            },
        },
        on_attach = utils.on_attach,
    })
end

M.bashls = function()
    require('lspconfig').bashls.setup({
        on_attach = utils.on_attach,
    })
end

M.basedpyright = function()
    require('lspconfig').basedpyright.setup({
        on_attach = function(_, bufnr)
            utils.on_attach(_, bufnr)
            vim.keymap.set('n', '<Leader>fh', '<cmd>PyrightOrganizeImports<CR>', {
                noremap = true,
                silent = true,
                buffer = bufnr,
                desc = "Organize imports",
            })
        end
    })
end

M.haskell = function()
    require('lspconfig').hls.setup {
        on_attach = utils.on_attach,
    }
end

M.latex = function()
    require('lspconfig').texlab.setup({
        on_attach = utils.on_attach,
        settings = {
            texlab = {
                chktex = {
                    onEdit = true,
                    onOpenAndSave = true,
                },
                auxDirectory = 'build',
            },
        },
    })
end

M.ansible = function()
    require('lspconfig').ansiblels.setup({
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
end

local vscode_ls_config = {
    on_attach = utils.on_attach,
    capabilities = capabilities,
}

M.html = function()
    require('lspconfig').html.setup(vscode_ls_config)
end

M.css = function()
    require('lspconfig').cssls.setup(vscode_ls_config)
end

M.ocaml = function()
    require('lspconfig').ocamllsp.setup({
        on_attach = utils.on_attach,
    })
end

M.c3 = function()
    require('lspconfig').c3_lsp.setup({})
end

M.gh = function()
    require('lspconfig').gh_actions_ls.setup({
        filetypes = { 'yaml', 'yaml.github' },
    })
end

return M
