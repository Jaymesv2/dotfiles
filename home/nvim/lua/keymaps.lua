vim.g.mapleader = ' '
-- vim.g.maplocalleader = ','

-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize +2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize -2<CR>', opts)

-- reset 
vim.keymap.set('n', '<Leader>h', ':noh<CR>')
-- map <leader>o :setlocal spell! spelllang=en_us<CR>
-- map <leader>n :NERDTreeToggle<CR>
vim.keymap.set('n', '<Leader>n', function() vim.cmd('NvimTreeToggle')  end)

vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>Y', '"*y')
vim.keymap.set('n', '<Leader>P', '"*p')

vim.keymap.set('n', '<Leader>ff', function() require('telescope.builtin').find_files() end)
vim.keymap.set('n', '<Leader>fg', function() require('telescope.builtin').live_grep() end )
vim.keymap.set('n', '<Leader>fb', function() require('telescope.builtin').buffers() end)
vim.keymap.set('n', '<Leader>fh', function() require('telescope.builtin').help_tags() end )
vim.keymap.set('n', '<Leader>fc', function() require('telescope.builtin').tags() end)




-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)


vim.keymap.set("n", "<leader>bp", function()
    require('cokeline.mappings').pick("focus")
end, { desc = "Pick a buffer to focus" })


