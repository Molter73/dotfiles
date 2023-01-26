local M = {}

local format_buf = function(buf, extra_args)
    -- Read all lines from current buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if next(lines) == nil then
        print("Failed to read current buffer")
        return
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_call(buf, function()
        local args = { 'jq' }

        for _, value in ipairs(extra_args or {}) do
            table.insert(args, value)
        end

        vim.api.nvim_cmd({
            cmd = '!',
            args = args,
            range = { 0, vim.api.nvim_buf_line_count(buf) },
            mods = {
                silent = true,
            }
        }, { output = false })
    end)

    local output = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if next(output) == nil then
        print("Failed to read scratch buffer")
        return
    end

    if string.sub(output[1], 1, 1) ~= "{" then
        print("Failed to format buffer")
        return
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

local execute_jq = function(extra_args)
    if vim.bo.filetype ~= 'json' then
        return
    end

    if vim.fn.executable('jq') == 0 then
        print("jq not found")
        return
    end

    -- create a new unlisted, scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    if buf == 0 then
        print("Failed to create scratch buffer")
    end

    format_buf(buf, extra_args)

    vim.api.nvim_buf_delete(buf, { force = true, unload = false })
end

M.format_json = function()
    execute_jq()
end

M.minify_json = function()
    execute_jq({ '-c' })
end
return M
