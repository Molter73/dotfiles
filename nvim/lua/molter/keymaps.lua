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

-- Simplified window navigation
vim.keymap.set('n', '<S-C-h>', '<C-w>h', { noremap = true, desc = 'Jump to left window' })
vim.keymap.set('n', '<S-C-j>', '<C-w>j', { noremap = true, desc = 'Jump to upper window' })
vim.keymap.set('n', '<S-C-k>', '<C-w>k', { noremap = true, desc = 'Jump to lower window' })
vim.keymap.set('n', '<S-C-l>', '<C-w>l', { noremap = true, desc = 'Jump to right window' })
