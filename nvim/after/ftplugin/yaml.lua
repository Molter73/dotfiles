local bufname = vim.api.nvim_buf_get_name(0)

if string.find(bufname, '/ansible/') then
    vim.bo.filetype = 'yaml.ansible'
end
