local main_width = 0.65
local secondary_width = 1 - main_width

local get_window_data = function(window)
    return {
        handle = window,
        position = vim.api.nvim_win_get_position(window),
        height = vim.api.nvim_win_get_height(window),
        width = vim.api.nvim_win_get_width(window),
    }
end

local focus_window = function()
    local secondary_windows = {}
    local curr_window = get_window_data(vim.api.nvim_get_current_win())
    local width = curr_window.width

    local i = 1
    for _, window in ipairs(vim.api.nvim_list_wins()) do
        if window ~= curr_window.handle then
            secondary_windows[i] = get_window_data(window)
            width = width + secondary_windows[i].width
            i = i + 1
        end
    end

    if i <= 1 then
        return
    end

    local min_width = math.floor((width * secondary_width) / (i - 1))
    local max_width = math.floor(width * main_width)

    if (min_width * (i - 1)) + max_width < width then
        max_width = max_width + 1
    end

    for _, window in ipairs(secondary_windows) do
        if window.handle ~= curr_window then
            vim.api.nvim_win_set_width(window.handle, min_width)
        end
    end

    vim.api.nvim_win_set_width(curr_window.handle, max_width)

    --print(vim.inspect(curr_window))
    --print(vim.inspect(secondary_windows))
end

vim.api.nvim_create_user_command('Window', focus_window, {})

vim.api.nvim_create_augroup('WindowFocuser', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
    group = 'WindowFocuser',
    desc = 'Change size of Windows',
    callback = focus_window,
})
