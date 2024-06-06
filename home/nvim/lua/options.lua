-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.o.termguicolors = true

-- vim.o.wildmode={ 'longest', 'list', 'full' }
vim.o.clipboard = 'unnamedplus'
-- vim.o.completeopt = {'menu', 'menuone', 'noselect'}
vim.o.mouse = 'a'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.showmode = false


vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true


