local treeapi = require("nvim-tree.api").tree
vim.g.should_reopen_nvimtree = false
-- if nvimtree is open in the current tab then, when switching, it should be closed in the one thats being left and opened in the target
require("scope").setup({
    hooks = {
        post_tab_enter = function()
            --[[ if vim.g.should_reopen_nvimtree == true then
                vim.notify("trying to open tree in new tab")
                --treeapi.open()
                vim.cmd('NvimTreeOpen')
            end ]]
        end,

        -- pre_tab_enter = function() end,
        -- pre_tab_leave = function() end,

        post_tab_leave = function()
            --[[ vim.g.should_reopen_nvimtree = false;
            if (treeapi.is_visible({tabpage = vim.api.nvim_get_current_tabpage() })) then
            -- if treeapi.is_visible({ }) then
                vim.notify("the thing was visible")
                vim.g.should_reopen_nvimtree = true;
                vim.cmd('NvimTreeClose')
                -- treeapi.close()
            end ]]
        end,
        -- pre_tab_close = function() end,
        -- post_tab_close = function() end,
    },
})
require("telescope").load_extension("scope")
