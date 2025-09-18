-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.o.termguicolors = true

-- vim.o.wildmode={ 'longest', 'list', 'full' }

vim.o.breakindent = true

vim.o.clipboard = 'unnamedplus'
-- vim.o.completeopt = {'menu', 'menuone', 'noselect'}
vim.o.mouse = 'a'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- vim.o.number = true
-- vim.o.relativenumber = true
--
vim.opt.nu = true
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
-- -- vim.o.statuscolumn = "%s %l %r "

vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.showmode = false


vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.g.vimtex_view_method = "zathura"


vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.lazyredraw = true
vim.o.showmatch = true -- Highlight matching parentheses, etc
