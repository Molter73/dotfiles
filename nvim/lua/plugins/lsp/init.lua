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
                }
            })

            vim.lsp.config('gh_actions_ls', {
                filetypes = { 'yaml', 'yaml.github' },
            })

            vim.lsp.enable({
                'gh_actions_ls',
                'yamlls',
            })

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

    -- Other full completion sources

    -- See hrsh7th's other plugins for more completion sources!

    -- To enable more of the features of rust-analyzer, such as inlay hints and more!
    {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        opts = {
            tools = {
                -- rust-tools options
                autoSetHints = true,
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
            -- all the opts to send to nvim-lspconfig
            -- these override the defaults set by rust-tools.nvim
            -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
            server = {
                cmd = { 'rustup', 'run', 'stable', 'rust-analyzer', },
                -- on_attach is a callback called when the language server attachs to the buffer
                on_attach = utils.on_attach,
                settings = {
                    -- to enable rust-analyzer settings visit
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ['rust-analyzer'] = {
                        -- enable clippy on save
                        checkOnSave = {
                            command = 'clippy'
                        },
                    }
                }
            },
        },
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
    },
}
