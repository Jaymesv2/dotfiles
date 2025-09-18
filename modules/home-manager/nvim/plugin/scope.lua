--[[ local treeapi = require("nvim-tree.api").tree
-- if nvimtree is open in the current tab then, when switching, it should be closed in the one thats being left and opened in the target
require("scope").setup({
    hooks = {
        post_tab_enter = function()
            -- if treeapi.is_visible({any_tabpage = true}) then
            --     vim.notify("The tree is visible somewhere")
            --     treeapi.close_in_all_tabs()
            --     treeapi.open({current_window = true})
            -- end
        end,

        -- pre_tab_enter = function() end,
        -- pre_tab_leave = function() end,

        post_tab_leave = function() end,
        -- pre_tab_close = function() end,
        -- post_tab_close = function() end,
    },
})
require("telescope").load_extension("scope") ]]
