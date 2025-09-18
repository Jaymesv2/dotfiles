vim.loader.enable()
--vim.loader.disable()

require('neovide')

require('options')

require('keymaps')



vim.g.lz_n = {
    ---@type fun(name: string)
    load = function(_) end
}


--vim.cmd('syntax enable')
--vim.cmd('filetype plugin indent on')
vim.cmd.syntax('enable')
vim.cmd.filetype('plugin', 'indent', 'on')
-- vim.cmd.packadd('cfilter')

-- require("auto-session").setup {
--   log_level = "error",
--
--   cwd_change_handling = {
--     restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
--     pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
--     post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
--       require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
--     end,
--   },
-- }


-- local wk = require('which-key')



vim.keymap.set('n', '<leader>k', ':WhichKey<CR>', { desc = "Whichkey"} )

-- packadd("tokyonight.nvim")

require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  style = "night",
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,

  cache = true,
})

vim.cmd[[colorscheme tokyonight]]

require('Comment').setup()

require("toggleterm").setup( {
    open_mapping = [[<C-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
    winbar = {
      enabled = true,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end
    },
} )

require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
    },
})

require("gitsigns").setup()

require("nvim-surround").setup()

local opts = { noremap=true, silent=true }

require("bufresize").setup({
    register = {
        keys = {
            { "n", "<C-w><", "<C-w><", opts },
            { "n", "<C-w>>", "<C-w>>", opts },
            { "n", "<C-w>+", "<C-w>+", opts },
            { "n", "<C-w>-", "<C-w>-", opts },
            { "n", "<C-w>_", "<C-w>_", opts },
            { "n", "<C-w>=", "<C-w>=", opts },
            { "n", "<C-w>|", "<C-w>|", opts },
            { "", "<LeftRelease>", "<LeftRelease>", opts },
            { "i", "<LeftRelease>", "<LeftRelease><C-o>", opts },
        },
        trigger_events = { "BufWinEnter", "WinEnter" },
    },
    resize = {
        keys = {},
        trigger_events = { "VimResized" },
        increment = false,
    },
})

require('smart-splits').setup({
  resize_mode = {
    hooks = {
      on_leave = require('bufresize').register,
    },
  },
})
-- require("hbac").setup({
--   autoclose     = true, -- set autoclose to false if you want to close manually
--   threshold     = 10, -- hbac will start closing :unedited buffers once that number is reached
--   close_command = function(bufnr)
--     vim.api.nvim_buf_delete(bufnr, {})
--   end,
--   close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
--   telescope = {
--     -- See #telescope-configuration below
--   },
-- })

require("notify")
require('dressing').setup({
    input = {
        enable = true,
    },
})
vim.notify = require("notify")

vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)', { desc = 'Leap backward' })
vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap across buffers' } )

require('renamer').setup({with_popup=true})









require('lean').setup{ mappings = true }









local g = vim.g
local keymap = vim.keymap
local telescope = require('telescope')
local keymap_opts = { noremap = true, silent = true }


---@return HTOpts
g.haskell_tools = function()
  ---@type HTOpts
  local ht_opts = {
    tools = {
      repl = {
        handler = 'toggleterm',
        auto_focus = false,
      },
      codeLens = {
        autoRefresh = true,
      },
      definition = {
        hoogle_signature_fallback = true,
      },
      -- log = {
      --     level = vim.log.levels.DEBUG,
      -- },
    },
    hls = {
      -- for hls development
      -- cmd = { 'cabal', 'run', 'haskell-language-server' },
      on_attach = function(_, bufnr, ht)
        local desc = function(description)
          return vim.tbl_extend('keep', keymap_opts, { buffer = bufnr, desc = description })
        end
        keymap.set('n', 'gh', ht.hoogle.hoogle_signature, desc('haskell: [h]oogle signature search'))
        keymap.set('n', '<space>tg', telescope.extensions.ht.package_grep, desc('haskell: [t]elescope package [g]rep'))
        keymap.set('n', '<space>cr', function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end, { buffer = bufnr, desc = "reload code lenses"} )
        keymap.set(
          'n',
          '<space>th',
          telescope.extensions.ht.package_hsgrep,
          desc('haskell: [t]elescope package grep [h]askell files')
        )
        keymap.set(
          'n',
          '<space>tf',
          telescope.extensions.ht.package_files,
          desc('haskell: [t]elescope package [f]iles')
        )
        keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, desc('haskell: [e]valuate [a]ll'))
      end,
      default_settings = {
        haskell = {
          -- formattingProvider = 'stylish-haskell',
          maxCompletions = 10,
        },
      },
    },
  }
  return ht_opts
end


local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config({
  virtual_text = false,
})


-- A helper is also provided to toggle, which is convenient for mappings:

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  --virtual_text = false,
  virtual_lines = {
    -- To show virtual lines only for the current line's diagnostics:
    only_current_line = false,
    -- If you don't want to highlight the entire diagnostic line, use:
    highlight_whole_line = false,
  },



  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
  inlay_hints = {
    enabled = true,
    --exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
  },
  -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the code lenses.
  codelens = {
    enabled = true,
  },
}



-- require('plugin.bufferline')
-- require('plugin.harpoon')
-- require('plugin.illuminate')
-- require('plugin.indent-blankline')
-- require('plugin.iron')
-- require('plugin.lspconfig')
-- require('plugin.lualine')
-- require('plugin.nvim-autopairs')
-- require('plugin.nvim-tree')
-- require('plugin.overseer')
-- -- require('plugin.scope')
-- require('plugin.spider')
-- require('plugin.statuscol')
-- require('plugin.telescope')
-- require('plugin.treesitter')
-- require('plugin.ufo')
-- require('plugin.whichkey')



--lua/code_action_utils.lua
--local M = {}

-- local function code_action_listener()
--   local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
--   local params = vim.lsp_utils.make_range_params()
--   params.context = context
--   vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx, config)
--       if result ~= "" then
--           -- vim.notify("got a code action :)")
--       end
--     -- do something with result - e.g. check if empty and show some indication such as a sign
--   end)
-- end
-- -- return M
--
-- vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
--   group = vim.api.nvim_create_augroup("code_action_sign", { clear = true }),
--   callback = function()
--     code_action_listener()
--   end,
-- })


-- require("actions-preview").setup {
--   telescope = {
--     sorting_strategy = "ascending",
--     layout_strategy = "vertical",
--     layout_config = {
--       width = 0.8,
--       height = 0.9,
--       prompt_position = "top",
--       preview_cutoff = 20,
--       preview_height = function(_, _, max_lines)
--         return max_lines - 15
--       end,
--     },
--   },
-- }



-- local api = vim.api
-- local ns_id = api.nvim_create_namespace('demo')
--
-- local function dumb() 
--
--     local bnr = vim.fn.bufnr('%')
--
--     local line_num,col_num = unpack(vim.api.nvim_win_get_cursor(0))
--
--     print(line_num, col_num)
--     local lines = {}
--     lines[1] =  {{"line one", "IncSearch"}}
--     lines[2] =  {{"line two", "DiagnosticVirtualTextOk"}}
--     lines[3] =  {{"line three", "IncSearch"}}
--     local vtxtopts = {
--       -- end_line = 10,
--       id = 1,
--       -- virt_text = {{"demo", "IncSearch"}},
--       -- virt_text_pos = 'overlay',
--       -- virt_text = {{"pogfish", "IncSearch"}},
--       virt_lines = lines,
--       virt_lines_above = true,
--       -- virt_text_win_col = 20,
--     }
--
--     local mark_id = api.nvim_buf_set_extmark(bnr, ns_id, line_num-1, col_num, vtxtopts)
-- end
--
-- vim.api.nvim_create_autocmd('CursorMoved', {
--   -- once = true,
--   callback = function(args)
--     if vim.g.dumb_enabled then
--         dumb()
--     end
--   end,
-- })
--
-- vim.g.dumb_enabled = false
--
--
-- -- vim.keymap.set('n', '<leader>cr', function()
-- --     dumb()
-- -- end)
--
-- vim.keymap.set('n', '<leader>ct', function()
--     vim.g.dumb_enabled = not vim.g.dumb_enabled
-- end)

-- require('lz.n').load("plugin")
