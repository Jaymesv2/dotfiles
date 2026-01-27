require'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

require("nvim-treesitter-textobjects").setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
  move = {
    -- whether to set jumps in the jumplist
    set_jumps = true,
  },
}

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

local wk = require("which-key")

local toselect = require "nvim-treesitter-textobjects.select"

wk.add( {
    mode = { "x", "o" },
    group = "select",
    { "am", function() toselect.select_textobject("@function.outer", "textobjects") end, desc = "outer function" },
    { "im", function() toselect.select_textobject("@function.inner", "textobjects") end, desc = "inner function" },
    -- { "ac", function() toselect.select_textobject("@class.outer", "textobjects") end , desc = "outer class" },
    -- { "ic", function() toselect.select_textobject("@class.inner", "textobjects") end, desc = "inner class" },
    { "ac", function() toselect.select_textobject("@conditional.outer", "textobjects") end , desc = "outer conditional" },
    { "ic", function() toselect.select_textobject("@conditional.inner", "textobjects") end, desc = "inner conditional" },
    { "as", function() toselect.select_textobject("@local.scope", "locals") end, desc = "Local scope" }
})

vim.keymap.set("n", "<leader>a", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end)

vim.keymap.set("n", "<leader>A", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
end)

local tomove = require("nvim-treesitter-textobjects.move")
wk.add({
    mode = {'n','x','o'},
    group = "movement",
                    -- keymaps
                    -- You can use the capture groups defined in `textobjects.scm`
    { "]m", function() tomove.goto_next_start("@function.outer", "textobjects") end, desc = "next function start"},
    { "]]", function() tomove.goto_next_start("@class.outer", "textobjects") end, desc = "next class start"},
    { "[m", function() tomove.goto_previous_start("@function.outer", "textobjects") end, desc = "prev function start" },
    { "[[", function() tomove.goto_previous_start("@class.outer", "textobjects") end, desc = "prev class start" },

    --       -- You can also pass a list to group multiple queries.
    -- {  "]o", function() tomove.goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects") end }
    --

    { "]M", function() tomove.goto_next_end("@function.outer", "textobjects") end, desc = "next function end" },
    { "][", function() tomove.goto_next_end("@class.outer", "textobjects") end, desc = "next class end" },
    { "[M", function() tomove.goto_previous_end("@function.outer", "textobjects") end, desc = "prev function end" },
    { "[]", function() tomove.goto_previous_end("@class.outer", "textobjects") end, desc = "prev class end" },

    { "]c", function() tomove.goto_next_start("@call.outer", "textobjects") end, desc = "next call start" },
    { "[c", function() tomove.goto_previous_start("@call.outer", "textobjects") end, desc = "next call end" },

    -- { "]p", function() tomove.goto_next_start("@parameter.outer", "textobjects") end, desc = "next parameter start" },
    -- { "[p", function() tomove.goto_previous_start("@parameter.outer", "textobjects") end, desc = "previous parameter start" },

          -- Go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
    { "]d", function() tomove.goto_next("@conditional.outer", "textobjects") end },
    { "[d", function() tomove.goto_previous("@conditional.outer", "textobjects") end },

          -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
    { "]s", function() tomove.goto_next_start("@local.scope", "locals") end },
    { "]z", function() tomove.goto_next_start("@fold", "folds") end }
})

local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- This repeats the last query with always previous direction and to the start of the range.
vim.keymap.set({ "n", "x", "o" }, "<home>", function()
  ts_repeat_move.repeat_last_move({forward = false, start = true})
end)

-- This repeats the last query with always next direction and to the end of the range.
vim.keymap.set({ "n", "x", "o" }, "<end>", function()
  ts_repeat_move.repeat_last_move({forward = true, start = false})
end)

