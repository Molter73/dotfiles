require("nvim-lsp-installer").setup {
    automatic_installation = true
}

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
                    async = false,
                })
            end
        })
    end,
})

-- This function is used on every lsp server
local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>fr', vim.lsp.buf.format, opts)
end

local rust_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    on_attach(_, bufnr)

    vim.cmd([[
        set makeprg=cargo\ build
    ]])

    vim.keymap.set('n', '<Leader>m', '<CMD>make<CR>', opts)
end

local nvim_lsp = require 'lspconfig'

require('rust-tools').setup({
    tools = { -- rust-tools options
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
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = rust_attach,
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
})

nvim_lsp.yamlls.setup({})

-- clangd setup
local root_pattern = nvim_lsp.util.root_pattern('.git')

local function project_name_to_container_name()
    -- Turn the name of the current file into the name of an expected container, assuming that
    -- the container running/building this file is named the same as the basename of the project
    -- that the file is in
    --
    -- The name of the current buffer
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Turned into a filename
    local filename = nvim_lsp.util.path.is_absolute(bufname) and bufname or
        nvim_lsp.util.path.join(vim.loop.cwd(), bufname)

    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or nvim_lsp.util.path.dirname(filename)

    -- And finally perform what is essentially a `basename` on this directory
    return vim.fn.fnamemodify(nvim_lsp.util.find_git_ancestor(project_dirname), ':t')
end

nvim_lsp.clangd.setup({
    on_attach = on_attach,
    cmd = {
        "cclangd",
        project_name_to_container_name(),
    },
})

nvim_lsp.cmake.setup({})

nvim_lsp.sumneko_lua.setup {
    on_attach = on_attach,
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

-- golang setup
nvim_lsp.gopls.setup({
    on_attach = on_attach,
})

-- BASH setup x_x
nvim_lsp.bashls.setup({
    on_attach = on_attach,
})

-- Python setup
nvim_lsp.jedi_language_server.setup({
    on_attach = on_attach,
})

-- haskell language server
nvim_lsp.hls.setup {
    on_attach = on_attach,
}

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require('cmp')
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
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
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    },
})
