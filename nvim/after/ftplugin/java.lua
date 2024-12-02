-- Setup jdtls for current buffer
local jdtls = require('jdtls')

local format = function()
    vim.lsp.buf.format({
        formatting_options = {
            insertSpaces = false,
            trimTrailingWhitespace = true,
            insertFinalNewline = true,
            trimFinalNewlines = true,
        },
    })
    jdtls.organize_imports()
end

local on_attach = function(data, bufnr)
    require('plugins.lsp.utils').on_attach(data, bufnr)

    vim.keymap.set('n', '<Leader>fr', format,
        { noremap = true, silent = true, buffer = bufnr, desc = '[F]o[R]mat buffer' })
end

local settings = {
    java = {
        format = {},
        runtimes = {
            {
                name = "JavaSE-1.8",
                path = "/Library/Java/JavaVirtualMachines/jdk1.8.0_351.jdk",
            },
        },
    }
}

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local jdtls_cache = vim.fn.stdpath('cache') .. '/jdtls'
local workspace_dir = jdtls_cache .. '/workspace/' .. project_name
local config_dir = os.getenv('HOME') .. '/.local/lsp/jdtls/config_linux/'

if string.find(vim.api.nvim_buf_get_name(0), 'mastermind') then
    settings.java.format = {
        enabled = false,
    }

    on_attach = require('plugins.lsp.utils').on_attach
else
    -- Setting options
    vim.opt_local.expandtab = false
end

local config = {
    cmd = {
        'jdtls',
        '--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '--jvm-arg=-Dosgi.bundles.defaultStartLevel=4',
        '--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product',
        '--jvm-arg=-Dlog.protocol=true',
        '--jvm-arg=-Dlog.level=ALL',
        '-configuration', config_dir,
        '-data', workspace_dir,
    },
    root_dir = require('jdtls.setup').find_root({ 'pom.xml', '.git' }),
    on_attach = on_attach,
    settings = settings,
}

local jdtlsau = vim.api.nvim_create_augroup("JDTLS", { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = jdtlsau,
    buffer = 0,
    callback = format
})

jdtls.start_or_attach(config)
