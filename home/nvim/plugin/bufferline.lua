
local bufferline = require('bufferline')
bufferline.setup({
    options = {
        mode = "buffers",
        --mode = "tabs",
        diagnostics = "nvim_lsp",
        style_preset = bufferline.style_preset.default,
        themable = true,
        -- numbers = 
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        offsets = {
            {
                filetype = "OverseerList",
                text = function() return "Overseer" end,
                --highlight = "Directory",
                text_align = "center", -- | "left" | "right"
                separator = true,
            },
            {
                filetype = "NvimTree",
                text = function() return "File Explorer" end,
                --highlight = "Directory",
                text_align = "center", -- | "left" | "right"
                separator = true,
            },
        }
    },
})

vim.keymap.set("n", "<leader>bp", '<Cmd>BufferLinePick<CR>', { desc = "Pick a buffer to focus" })
vim.keymap.set("n", "<leader>bD", '<Cmd>BufferLinePickClose<CR>', { desc = "Pick a buffer to focus" })

vim.keymap.set("n", "<leader>1", function() bufferline.go_to(1) end, { desc = "Go to buffer 1"})
vim.keymap.set("n", "<leader>2", function() bufferline.go_to(2) end, { desc = "Go to buffer 2"})
vim.keymap.set("n", "<leader>3", function() bufferline.go_to(3) end, { desc = "Go to buffer 3"})
vim.keymap.set("n", "<leader>4", function() bufferline.go_to(4) end, { desc = "Go to buffer 4"})
vim.keymap.set("n", "<leader>5", function() bufferline.go_to(5) end, { desc = "Go to buffer 5"})
vim.keymap.set("n", "<leader>6", function() bufferline.go_to(6) end, { desc = "Go to buffer 6"})
vim.keymap.set("n", "<leader>7", function() bufferline.go_to(7) end, { desc = "Go to buffer 7"})
vim.keymap.set("n", "<leader>8", function() bufferline.go_to(8) end, { desc = "Go to buffer 8"})
vim.keymap.set("n", "<leader>9", function() bufferline.go_to(9) end, { desc = "Go to buffer 9"})
vim.keymap.set("n", "<leader>$", function() bufferline.go_to(-1) end, { desc = "Go to buffer -1"})

vim.keymap.set("n", "<leader>,", function() bufferline.move_to(1) end, { desc = "Move to the next buffer"})
vim.keymap.set("n", "<leader>.", function() bufferline.move_to(-1) end, { desc = "Move to the previous buffer"})
