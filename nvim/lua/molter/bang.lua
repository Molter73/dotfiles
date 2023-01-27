local shebang = '#!/usr/bin/env'

local starts_with = function(str, prefix)
    local prefix_len = #prefix

    if #str < prefix_len then
        return false
    end

    return string.sub(str, 0, prefix_len) == prefix
end

local make_executable = function()
    local file_path = vim.fn.expand('%:p')

    return vim.fn.jobstart({ 'chmod', '+x', file_path }) > 0
end

vim.api.nvim_create_user_command('Bang', function(_)
    if vim.bo.ft == '' then
        vim.bo.ft = 'sh'
    end

    if vim.bo.ft ~= 'sh' then
        print('Not running Bash - filetype:', vim.bo.ft)
        return
    end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)

    if first_line == nil or starts_with(first_line[1], shebang) then
        return
    end

    vim.api.nvim_buf_set_lines(0, 0, 0, false, { shebang .. ' bash', '' })

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = make_executable,
        once = true,
        desc = 'Make file executable after saving',
    })
end, { desc = 'Add shebang to current buffer' })

vim.api.nvim_create_user_command('BangMakeExec', make_executable, { desc = 'Make current file executable' })
