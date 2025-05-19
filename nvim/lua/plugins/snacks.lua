vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local spinner = {
            "( ●    )",
            "(  ●   )",
            "(   ●  )",
            "(    ● )",
            "(     ●)",
            "(    ● )",
            "(   ●  )",
            "(  ●   )",
            "( ●    )",
            "(●     )"
        }
        vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
                notif.icon = ev.data.params.value.kind == "end" and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 100)) % #spinner + 1]
            end,
        })
    end,
})

return {
    "folke/snacks.nvim",
    opts = {
        styles = {
            input = {
                relative = 'cursor',
                row = 1,
                col = 0,
            },
        },
        input = {},
        notifier = {},
        picker = {
            ui_select = true,
        },
    },
}
