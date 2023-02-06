local supported_languages = {
    sh = 'bash',
    python = 'python3',
}

local starts_with = function(str, prefix)
    local prefix_len = #prefix

    if #str < prefix_len then
        return false
    end

    return string.sub(str, 0, prefix_len) == prefix
end

local make_executable = function(args)
    local file_path = args.file or vim.fn.expand('%:p')

    return vim.fn.jobstart({ 'chmod', '+x', file_path }) > 0
end

local get_filetype = function(ft)
    if vim.bo.ft ~= '' then
        return vim.bo.ft
    end

    if ft == nil or #ft >= 2 then
        return nil
    elseif #ft == 1 then
        return ft[1]
    end

    return 'sh'
end

vim.api.nvim_create_user_command('Bang', function(params)
    local filetype = get_filetype(params.fargs)
    if filetype == nil then
        print('Invalid arguments:', filetype)
        return
    end

    if supported_languages[filetype] == nil then
        print('Not running Bang - filetype:', filetype)
        return
    end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    local shebang = '#!/usr/bin/env'

    if first_line == nil or starts_with(first_line[1], shebang) then
        return
    end

    local replacement = { shebang .. ' ' .. supported_languages[filetype], '' }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, replacement)

    -- Ensure filetype is properly set
    vim.bo.ft = filetype

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = make_executable,
        once = true,
        desc = 'Make file executable after saving',
    })
end, { nargs = '?', desc = 'Add shebang to current buffer' })

vim.api.nvim_create_user_command('BangMakeExec', make_executable, { desc = 'Make current file executable' })
