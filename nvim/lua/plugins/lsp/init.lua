local utils = require('plugins.lsp.utils')
local servers = require('plugins.lsp.servers')

return {
    -- nvim LSP
    {
        'neovim/nvim-lspconfig',
        branch = 'master',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            for _, server in pairs(servers) do
                server()
            end
            --
            -- LSP specific autocommands
            local lspau = vim.api.nvim_create_augroup("LSP", { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = lspau,
                pattern = { 'lua', 'rust', 'go', 'haskell' },
                callback = function()
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = lspau,
                        buffer = 0,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = {
                                    trimTrailingWhitespace = true,
                                    insertFinalNewline = true,
                                    trimFinalNewlines = true,
                                },
                                async = false,
                            })
                        end
                    })
                end,
            })

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
                    -- Add tab support
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
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
        'jose-elias-alvarez/null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = function()
            local null_ls = require('null-ls')
            return {
                sources = {
                    -- diagnostics
                    null_ls.builtins.diagnostics.actionlint,
                    null_ls.builtins.diagnostics.ansiblelint,
                    null_ls.builtins.diagnostics.flake8,
                    null_ls.builtins.diagnostics.hadolint,
                    null_ls.builtins.diagnostics.zsh,

                    -- formatters
                    null_ls.builtins.formatting.autopep8,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.google_java_format.with {
                        condition = function(_)
                            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
                            return project_name == 'mastermind'
                        end,
                    }
                }
            }
        end
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
    },
}
