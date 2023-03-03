local format = function()
    vim.lsp.buf.format({
        formatting_options = {
            insertSpaces = false,
            trimTrailingWhitespace = true,
            insertFinalNewline = true,
            trimFinalNewlines = true,
        },
    })
    require('jdtls').organize_imports()
end

local on_attach = function(data, bufnr)
    require('plugins.lsp.utils').on_attach(data, bufnr)

    vim.keymap.set('n', '<Leader>fr', format,
        { noremap = true, silent = true, buffer = bufnr, desc = '[F]o[R]mat buffer' })
end

local config = {
    cmd = { 'jdtls' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    on_attach = on_attach,
}

return {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
        local jdtlsau = vim.api.nvim_create_augroup("JDTLS", { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = jdtlsau,
            buffer = 0,
            callback = format
        })

        require('jdtls').start_or_attach(config)
    end
}
