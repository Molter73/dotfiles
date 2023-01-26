local null_ls = require('null-ls')

null_ls.setup({
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
    }
})
