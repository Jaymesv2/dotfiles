--[[
vim.g.nvim_tree_setup = false

-- OR setup with some options
local function setup()
    if vim.g.nvim_tree_setup then
        return;
    end
    vim.g.nvim_tree_setup = true

    --vim.keymap.set('n', '<Leader>n', function() vim.cmd('NvimTreeToggle')  end)

    require("nvim-tree").setup({
      on_attach = function(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
      vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    end,
      -- sort = {
      --   sorter = "case_sensitive",
      -- },
      -- view = {
      --   width = 30,
      -- },
      -- renderer = {
      --   group_empty = true,
      -- },
      -- filters = {
      --   dotfiles = true,
      -- },
    })
end

local keys = {
    {'n', '<Leader>n', function() vim.cmd('NvimTreeToggle')  end, {}}
}

-- local function unregister_lazy_keys()
--     for value, _ in ipairs(keys) do
--         vim.keymap.del(value[0], value[1],value[2] )
--         vim.keymap.add(value[0], value[1],)
--         print("hi")
--         
--     end
-- end

local function register_lazy_commands(commands)
    for _, name in ipairs(commands) do
        vim.api.nvim_create_user_command(name, function(args)
            for _, iname in ipairs(commands) do
                vim.api.nvim_del_user_command(iname)
            end
            setup()
            --vim.api.nvim_cmd(name, args)
        end, {})
    end
end


local function register_lazy_keys(keymaps)
    for _, value in ipairs(keymaps) do
        local modes = value[1]
        local key = value[2]
        local func = value[3]
        local opts
        if value[4] then
            opts = value[4]
        else
            opts = {}
        end

        vim.keymap.set(modes, key, function()
            setup()
            vim.keymap.del(modes, key)
            vim.keymap.set(modes, key, func, opts)
            func()
        end, opts)
    end
end


register_lazy_keys(keys)
register_lazy_commands({"NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose", "NvimTreeFocus", "NvimTreeRefresh", "NvimTreeCollapse", "NvimTreeFindFile", "NvimTreeClipboard"}) ]]

-- OR setup with some options
require("nvim-tree").setup({
  on_attach = function(bufnr)
  local api = require "nvim-tree.api"
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  -- default mappings
  api.config.mappings.default_on_attach(bufnr)
  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end,
})

vim.keymap.set('n', '<Leader>n', function() vim.cmd('NvimTreeToggle')  end)
