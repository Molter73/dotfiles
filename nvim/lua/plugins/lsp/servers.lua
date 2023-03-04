local M = {}

local utils = require('plugins.lsp.utils')

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
        on_attach = utils.on_attach,
        cmd = {
            "cclangd",
            utils.project_to_container(),
        },
    })
end

M.cmake = function()
    require('lspconfig').cmake.setup({})
end

M.golang = function()
    require('lspconfig').gopls.setup({
        on_attach = utils.on_attach,
    })
end

M.bashls = function()
    require('lspconfig').bashls.setup({
        on_attach = utils.on_attach,
    })
end

M.jedi = function()
    require('lspconfig').jedi_language_server.setup({
        on_attach = utils.on_attach,
    })
end

M.haskell = function()
    require('lspconfig').hls.setup {
        on_attach = utils.on_attach,
    }
end

return M
