-- Options
-- Enables the clipboard between Vim/Neovim and other applications.
vim.opt.clipboard = 'unnamedplus'
-- Modifies the auto-complete menu to behave more like an IDE.
vim.opt.completeopt = 'noinsert,menuone,noselect'
vim.opt.shortmess:append('c')
vim.opt.cursorline = true -- Highlights the current line in the editor
vim.opt.hidden = true -- Hide unused buffers
vim.opt.autoindent = true -- Indent a new line
vim.opt.autoread = true -- Read buffers modified outside of Neovim
vim.opt.inccommand = 'split' -- Show replacements in a split screen
vim.opt.mouse = 'a' -- Allow to use the mouse in the editor
vim.opt.number = true -- Shows the line numbers
vim.opt.splitbelow = true -- Change the split screen behavior
vim.opt.splitright = true
vim.opt.title = true -- Show file title
vim.opt.wildmenu = true -- Show a more advance menu
vim.opt.cc = '80' -- Show at 80 column a border for good code style
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true -- Tabs are now 4 space wide
vim.opt.scrolloff = 20
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true
vim.opt.ttyfast = true -- Speed up scrolling in Vim
vim.opt.list = true
vim.opt.listchars = {
    tab = '==>',
    trail = '·',
    precedes = '<',
    extends = '>',
    multispace = '·',
    nbsp = '○',
}
vim.opt.updatetime = 200
vim.opt.hls = false
vim.g.mapleader = ' '
vim.opt.background = 'dark'
vim.opt.termguicolors = true
vim.opt.spell = true
