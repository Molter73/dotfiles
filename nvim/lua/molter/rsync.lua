local gosrc = os.getenv('GOPATH') .. '/src'
local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';' .. gosrc)

local rsync = vim.api.nvim_create_augroup('RSYNC', { clear = true })

if git_dir ~= "" then
    local cmd_check = "[ -d " .. vim.fn.getcwd() .. " ]"

    local dir_check = vim.fn.jobstart({ 'ssh', 'remote', cmd_check })
    if dir_check <= 0 then
        return
    end

    local exists = vim.fn.jobwait({ dir_check }, 5000)[1]

    if exists == 0 then
        vim.api.nvim_create_autocmd('BufWritePost', {
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
end
