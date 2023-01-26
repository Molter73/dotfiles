local relative_path = function()
    local starts_with = function(str, start)
        return string.sub(str, 1, #start) == start
    end

    local path = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()

    if starts_with(path, cwd) then
        return string.sub(path, #cwd + 2, -1)
    else
        return path
    end
end

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { relative_path },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}
