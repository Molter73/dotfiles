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
                    utils.format(false)
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
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        utils.format(false)
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

local lsp_config = function(name, caps)
    local capabilities = caps or vim.lsp.protocol.make_client_capabilities()

    vim.lsp.config(name, {
        on_attach = utils.on_attach,
        capabilities = capabilities,
    })
    vim.lsp.enable(name)
end

return {
    -- nvim LSP
    {
        'neovim/nvim-lspconfig',
        branch = 'master',
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('plugins.lsp.ansible')
            require('plugins.lsp.clangd')
            require('plugins.lsp.lua')
            require('plugins.lsp.rust')

            -- LSPs with simple configurations
            lsp_config('basedpyright')
            lsp_config('bashls')
            lsp_config('cssls', utils.capabilities.snippetSupport)
            lsp_config('gopls')
            lsp_config('html', utils.capabilities.snippetSupport)
            lsp_config('ocamllsp')

            vim.lsp.config('neocmake', {
                capabilities = utils.capabilities.snippetSupport,
            })

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

            vim.lsp.config('gh_actions_ls', {
                filetypes = { 'yaml', 'yaml.github' },
                init_options = { sessionToken = "" },
            })

            vim.lsp.enable({
                'gh_actions_ls',
                'yamlls',
            })

            vim.api.nvim_create_user_command('LspStop', function(arguments)
                local filter = { bufnr = vim.api.nvim_get_current_buf() }
                if arguments.fargs[1] then
                    filter.name = arguments.fargs[1]
                end
                vim.lsp.stop_client(vim.lsp.get_clients(filter))
            end, { desc = 'My LspStop', nargs = '?' })

            -- LSP specific autocommands
            local lspau = vim.api.nvim_create_augroup("LSP", { clear = true })
            formatter(lspau)
            go_formatter(lspau)

            -- Setup Completion
            -- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
            local cmp = require('cmp')
            cmp.setup({
                -- Enable LSP snippets
                snippet = {
                    expand = function(args)
                        require 'luasnip'.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    })
                },
                -- Installed sources
                sources = {
                    { name = 'luasnip' },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'buffer' },
                },
            })
        end,
    },

    -- Completion framework
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        branch = 'main',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
        },
    },

    -- Snippet completion source for nvim-cmp
    {
        "L3MON4D3/LuaSnip",
        event = 'InsertEnter',
        -- install jsregexp (optional!:).
        build = "make install_jsregexp"
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
    },
}
