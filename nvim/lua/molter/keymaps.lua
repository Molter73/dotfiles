-- Global Keymaps
-- netrw
vim.keymap.set('n', '<Leader>ej', '<cmd>Ex<CR>', { noremap = true, desc = 'Go to net-rw' })
vim.keymap.set('n', '<Leader>ev', '<cmd>Vex!<CR>', { noremap = true, desc = 'Open net-rw in new vertical split' })
vim.keymap.set('n', '<Leader>eh', '<cmd>Sex<CR>', { noremap = true, desc = 'Open net-rw in new horizontal split' })

-- Page up and down with auto-center
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- Navigate quickfixes
vim.keymap.set('n', ']q', '<cmd>cn<CR>', { noremap = true, desc = 'Next quickfix' })
vim.keymap.set('n', '[q', '<cmd>cp<CR>', { noremap = true, desc = 'Previous quickfix' })

-- pop-up diagnostics
vim.keymap.set('n', '<Leader>q', vim.diagnostic.open_float, { noremap = true, desc = 'Pop-up diagnostics' })

-- Trim line endings on demmand
vim.keymap.set('n', '<Leader>tt', require('molter.trimmers').newlines, { noremap = true, desc = 'Trim line endings' })

-- Format JSON with jq
local jq = require('molter.jq')
vim.keymap.set('n', '<Leader>jq', jq.format_json, { noremap = true, desc = 'Format JSON file' })
vim.keymap.set('n', '<Leader>jc', jq.minify_json, { noremap = true, desc = 'Minify JSON file' })
vim.keymap.set('n', '<Leader>jj', '<cmd>set filetype=json<CR>', { noremap = true, desc = 'Set filetype to JSON' })

-- Integrated terminal stuff
vim.keymap.set('n', '<Leader><Leader>t', ':vsplit term://zsh<CR>', {
    noremap = true,
    silent = true,
    desc = 'Launch a terminal',
})
vim.keymap.set('t', ',tq', '<C-\\><C-n>', { noremap = true, desc = 'Escape the terminal', })

-- BANG!
vim.keymap.set('n', '<Leader>bb', '<cmd>Bang sh<CR>', { noremap = true, desc = 'Set current file as executable bash', })
vim.keymap.set('n', '<Leader>bp', '<cmd>Bang python<CR>',
    { noremap = true, desc = 'Set current file as executable Python', })

-- Move lines around
vim.keymap.set('n', '<A-j>', ':m+<CR>==', { noremap = true, desc = 'Move line down', })
vim.keymap.set('n', '<A-k>', ':m-2<CR>==', { noremap = true, desc = 'Move line up', })
vim.keymap.set('i', '<A-k>', '<Esc>:m-2<CR>==gi', { noremap = true, desc = 'Move line up', })
vim.keymap.set('i', '<A-j>', '<Esc>:m+<CR>==gi', { noremap = true, desc = 'Move line down', })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, desc = 'Move selected lines down', })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, desc = 'Move selected lines up', })

-- Rsync-ing
local rsync = require('molter.rsync')
vim.keymap.set('n', '<Leader>rr', rsync.setup_autocommand, { noremap = true, desc = 'Start rsync', })
vim.keymap.set('n', '<Leader>rs', rsync.clear_autocommand, { noremap = true, desc = 'Stop rsync', })
