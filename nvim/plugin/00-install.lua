vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if kind ~= 'update' and kind ~= 'install' then return end
        if name == 'blink.cmp' then
            vim.notify('Installing blink.cmp...', vim.log.levels.INFO)
            local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
            if obj.code == 0 then
                vim.notify('Building blink.cmp done', vim.log.levels.INFO)
            else
                vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
            end
        elseif name == 'mkdp' then
            vim.notify('Installing markdown-preview...', vim.log.levels.INFO)
            local obj = vim.system({ 'yarn', 'install' }, { cwd = ev.data.path .. '/app' }):wait()
            if obj.code == 0 then
                vim.notify('Building markdown-preview done', vim.log.levels.INFO)
            else
                vim.notify('Building markdown-preview failed', vim.log.levels.ERROR)
            end
        end
    end
})
