local on_attach = function(data, bufnr)
    require('plugins.lsp.utils').on_attach(data, bufnr)

    vim.keymap.set('n', '<Leader>fr', function()
        vim.lsp.buf.format()
        require('jdtls').organize_imports()
    end, { noremap = true, silent = true, buffer = bufnr })
end

local config = {
    cmd = { 'jdtls' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    on_attach = on_attach,
}
require('jdtls').start_or_attach(config)
