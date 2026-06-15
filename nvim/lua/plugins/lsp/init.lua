local utils = require('plugins.lsp.utils')

local formatter = function(group)
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = {
            'lua',
            'rust',
            'html',
            'c',
            'cpp',
        },
        callback = function()
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = group,
                buffer = 0,
                callback = function()
                    utils.format({ async = false })
                end
            })
        end,
    })
end

local go_formatter = function(group)
    local callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- Taken from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
        --
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_clients({ id = cid }) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        utils.format({ async = false })
    end

    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'go' },
        callback = function()
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = group,
                buffer = 0,
                callback = callback,
            })
        end,
    })
end

local python_formatter = function(group)
    local callback = function()
        utils.format({
            async = false,
            filter = function(client) return client.name ~= 'basedpyright' end,
        })
    end

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python' },
        callback = function()
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = group,
                buffer = 0,
                callback = callback,
            })
        end
    })
end

return {
    -- nvim LSP
    {
        'neovim/nvim-lspconfig',
        branch = 'master',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('plugins.lsp.ansible')
            require('plugins.lsp.clangd')
            require('plugins.lsp.lua')
            require('plugins.lsp.rust')

            -- LSPs with simple configurations
            vim.lsp.config('cssls', { capabilities = utils.capabilities.snippetSupport })
            vim.lsp.config('html', { capabilities = utils.capabilities.snippetSupport })
            vim.lsp.config('neocmake', { capabilities = utils.capabilities.snippetSupport })

            vim.lsp.config('yamlls', {
                settings = {
                    yaml = {
                        schemas = {
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                        }
                    }
                },
                init_options = { sessionToken = "" },
            })

            vim.lsp.config('basedpyright', {
                on_attach = utils.on_attach,
                cmd = {
                    'uvx',
                    '--from', 'basedpyright',
                    'basedpyright-langserver', '--stdio'
                },
            })
            -- ruff doesn't have full LSP functionality yet, so we only
            -- bind a few supported functions
            vim.lsp.config('ruff', {
                on_attach = function(_, bufnr)
                    local opts = { noremap = true, silent = true, buffer = bufnr }

                    opts['desc'] = 'Code Action'
                    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
                    opts['desc'] = 'Format buffer'
                    vim.keymap.set({ 'n', 'v' }, '<Leader>fr', function() utils.format({ async = false }) end, opts)
                end,
            })

            vim.lsp.config('gh_actions_ls', {
                cmd = {
                    'actions-languageserver',
                    '--stdio',
                },
            })

            vim.lsp.enable({
                'basedpyright',
                'bashls',
                'gh_actions_ls',
                'gopls',
                'ocamllsp',
                'ruff',
                'yamlls',
            })

            -- LSP specific autocommands
            local lspau = vim.api.nvim_create_augroup("LSP", { clear = true })
            formatter(lspau)
            go_formatter(lspau)
            python_formatter(lspau)
        end,
    },
    {
        'mfussenegger/nvim-jdtls',
        enabled = false,
        ft = 'java',
    },
}
