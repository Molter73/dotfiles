local gosrc = os.getenv('GOPATH') .. '/src'

M = {
    autocmd_id = -1,
}

M.setup = function()
    vim.api.nvim_create_user_command('Rsync', function(params)
        local command = params.fargs[1]
        if command == 'up' then
            M.setup_autocommand()
        elseif command == 'down' then
            M.clear_autocommand()
        end
    end, {
        nargs = 1,
        complete = function()
            return { 'up', 'down', }
        end,
    })
end

M.status = function()
    if M.autocmd_id ~= -1 then
        return "RSYNC UP"
    end
    return ''
end

M.setup_autocommand = function()
    if M.autocmd_id ~= -1 then
        return
    end

    local rsync = vim.api.nvim_create_augroup('RSYNC', { clear = true })
    local cmd_check = "[ -d " .. vim.fn.getcwd() .. " ]"

    local dir_check = vim.fn.jobstart({ 'ssh', 'remote', cmd_check })
    if dir_check <= 0 then
        print('Failed to start check command')
        return
    end

    local exists = vim.fn.jobwait({ dir_check }, 5000)[1]
    if exists ~= 0 then
        print('Remote server not available or repo missing')
        return
    end

    M.autocmd_id = vim.api.nvim_create_autocmd('BufWritePost', {
        group = rsync,
        pattern = '*',
        callback = function()
            local file_in_repository = vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';' .. gosrc)
            if file_in_repository ~= '' then
                vim.cmd([[
                        silent !rsync -a %:p remote:%:p
                    ]])
            end
        end
    })
end

M.clear_autocommand = function()
    if M.autocmd_id ~= -1 then
        vim.api.nvim_del_autocmd(M.autocmd_id)
        M.autocmd_id = -1
    end
end

return M
