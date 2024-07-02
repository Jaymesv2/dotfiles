

local wk = require('which-key')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
-- vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
-- vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
-- vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
-- vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
-- vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
-- vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
-- vim.keymap.set('n', '<C-Left>', ':vertical resize +2<CR>', opts)
-- vim.keymap.set('n', '<C-Right>', ':vertical resize -2<CR>', opts)

-- reset 
-- map <leader>o :setlocal spell! spelllang=en_us<CR>
--
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
vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').marks() end, { desc = 'Telescope marks' })
vim.keymap.set('n', '<leader>fj', function() require('telescope.builtin').jumplist() end, { desc = 'Telescope Jumplist' })
vim.keymap.set('n', '<leader>fa', function() require('telescope.builtin').builtin() end, { desc = 'Telescope all' })


wk.register({
    f = {
        name = "find"
    }
}, {prefix = "<leader>"})

vim.keymap.set('n', '<leader>k', ':WhichKey<CR>', { desc = "Whichkey"} )



-------------------
-- Terminal mode --
-------------------

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)


-- vim.api.nvim_set_keymap("n", "<C-s>", ":lua ToggleTerm()<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>ot", [[:lua ToggleTerm("horizontal")<cr>]], opts)
-- vim.api.nvim_set_keymap("n", "<leader>ol", [[:lua ToggleTerm("vertical")<cr>]], opts)
-- vim.api.nvim_set_keymap("i", "<C-s>", "<esc>:lua ToggleTerm()<cr>", opts)
-- vim.api.nvim_set_keymap("t", "<C-s>", "<C-\\><C-n>:lua ToggleTerm()<cr>", opts)

vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>')
vim.keymap.set('n', '<leader>ta', ':ToggleTermToggleAll<CR>')
vim.keymap.set('n', '<leader>te', ':TermExec<CR>')
vim.keymap.set('n', '<leader>ts', ':TermSelect<CR>')







vim.keymap.set({'n', 'v'}, '<leader>oo', ':OverseerToggle<CR>', { desc = "Toggle overseer" } )

vim.keymap.set({'n', 'v'}, '<leader>or', ':OverseerRun<CR>')
vim.keymap.set({'n', 'v'}, '<leader>oi', ':OverseerInfo<CR>')
vim.keymap.set({'n', 'v'}, '<leader>oc', ':OverseerClose<CR>')
vim.keymap.set({'n', 'v'}, '<leader>ob', ':OverseerBuild<CR>')



function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end


-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')




-----------------
-- OverSeer --
-----------------

--vim.keymap.set('n', '<Leader>o', ':setlocal spell! spelllang=en_us<CR>')

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)




vim.keymap.set('i', '<F2>', function() require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })
vim.keymap.set('n', '<leader>rn', function () require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })
vim.keymap.set('v', '<leader>rn', function() require("renamer").rename() end, { noremap = true, silent = true }, { desc = 'Rename under cursor' })









-- local trim_spaces = true
--
-- vim.keymap.set("v", "<leader>s", function()
--     require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
-- end)
--     -- Replace with these for the other two options
--     -- require("toggleterm").send_lines_to_terminal("visual_lines", trim_spaces, { args = vim.v.count })
--     -- require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
--
-- -- For use as an operator map:
-- -- Send motion to terminal
-- vim.keymap.set("n", [[<leader><c-\>]], function()
--   set_opfunc(function(motion_type)
--     require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--   end)
--   vim.api.nvim_feedkeys("g@", "n", false)
-- end)
-- -- Double the command to send line to terminal
-- vim.keymap.set("n", [[<leader><c-\><c-\>]], function()
--   set_opfunc(function(motion_type)
--     require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--   end)
--   vim.api.nvim_feedkeys("g@_", "n", false)
-- end)
-- -- Send whole file
-- vim.keymap.set("n", [[<leader><leader><c-\>]], function()
--   set_opfunc(function(motion_type)
--     require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--   end)
--   vim.api.nvim_feedkeys("ggg@G''", "n", false)
-- end)
--
local ss = require('smart-splits')
local br = require('bufresize')

local function optsWithDesc(desc)
    return { noremap=true, silent=true, desc = desc }
end

vim.keymap.set('n', '<A-h>', function()
    ss.resize_left()
end, { desc = "Resize split left" })

vim.keymap.set('n', '<A-j>', function()
    ss.resize_down()
end, optsWithDesc("Resize split down"))

vim.keymap.set('n', '<A-k>', function()
    ss.resize_up()
end,   optsWithDesc("Resize split up" ))

vim.keymap.set('n', '<A-l>', function()
    ss.resize_right()
end, optsWithDesc("Resize split right"))

-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = "Move left"})
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = "Move down"})
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = "Move up"})
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = "Move right"})
vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous, { desc = "Move to previous split" })
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left, { desc = "Swap buffer left"})
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down, { desc = "Swap buffer down"})
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up, { desc = "Swap buffer up"})
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right, { desc = "Swap buffer right"})

vim.keymap.set(
	"t",
	"<leader>wd",
	"<C-\\><C-n>"
		.. ":lua require('bufresize').block_register()<cr>"
		.. "<C-w>c"
		.. ":lua require('bufresize').resize_close()<cr>",
    optsWithDesc("")
)

vim.keymap.set(
	"n",
	"<leader>wd",
	":lua require('bufresize').block_register()<cr>" .. "<C-w>c" .. ":lua require('bufresize').resize_close()<cr>",
	optsWithDesc("")
)

--local opts = { noremap = true, silent = true }
ToggleTerm = function(direction)
    local command = "ToggleTerm"
    if direction == "horizontal" then
        command = command .. " direction=horizontal"
    elseif direction == "vertical" then
        command = command .. " direction=vertical"
    end
    if vim.bo.filetype == "toggleterm" then
        require("bufresize").block_register()
        vim.api.nvim_command(command)
        require("bufresize").resize_close()
    else
        require("bufresize").block_register()
        vim.api.nvim_command(command)
        require("bufresize").resize_open()
        vim.api.nvim_command([[execute "normal! i"]])
    end
end


vim.keymap.set({'n', 'i', 't'}, "<C-s>", ToggleTerm, opts)



-- nvim keybind
vim.keymap.set('n', '<leader>ef', function() vim.cmd.SopsEncrypt() end, { desc = '[E]ncrypt [F]ile' })
vim.keymap.set('n', '<leader>df', function() vim.cmd.SopsDecrypt() end, { desc = '[D]ecrypt [F]ile' })

