vim.g.mapleader = ' '
-- vim.g.maplocalleader = ','

-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}


vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)', { desc = 'Leap backward' })
vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap across buffers' } )

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
vim.keymap.set('n', '<Leader>o', ':setlocal spell! spelllang=en_us<CR>')
-- map <leader>o :setlocal spell! spelllang=en_us<CR>
-- map <leader>n :NERDTreeToggle<CR>
vim.keymap.set('n', '<Leader>n', function() vim.cmd('NvimTreeToggle')  end)

vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>Y', '"*y')
vim.keymap.set('n', '<Leader>P', '"*p')

vim.keymap.set('n', '<Leader>ff', function() require('telescope.builtin').find_files() end, {desc = 'Telescope find files'})
vim.keymap.set('n', '<Leader>fg', function() require('telescope.builtin').live_grep() end, {desc = 'Telescope live grep'})
vim.keymap.set('n', '<Leader>fb', function() require('telescope.builtin').buffers() end, {desc = 'Telescope buffers'})
vim.keymap.set('n', '<Leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope help tags'})
vim.keymap.set('n', '<Leader>fc', function() require('telescope.builtin').tags() end, { desc = 'Telescope tags' })
vim.keymap.set('n', '<Leader>fr', function() require('telescope.builtin').registers() end, { desc = 'Telescope registers' })
vim.keymap.set('n', '<Leader>fs', function() require('telescope.builtin').spell_suggest() end, {desc = 'Telescope spell suggest'})
vim.keymap.set('n', '<leader>fk', function() require('telescope.builtin').keymaps() end, { desc = 'Telescope keymaps' })
vim.keymap.set('n', '<leader>fj', function() require('telescope.builtin').jumplist() end, { desc = 'Telescope Jumplist' })
vim.keymap.set('n', '<leader>fa', function() require('telescope.builtin').builtin() end, { desc = 'Telescope all' })

-------------------
-- Terminal mode --
-------------------

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)


-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)


vim.keymap.set("n", "<leader>bp", function()
    require('cokeline.mappings').pick("focus")
end, { desc = "Pick a buffer to focus" })




vim.keymap.set('i', '<F2>', function() require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })
vim.keymap.set('n', '<leader>rn', function () require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })
vim.keymap.set('v', '<leader>rn', function() require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })


