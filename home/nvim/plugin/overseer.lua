local overseer = require("overseer")

overseer.setup({
  strategy = {
    "toggleterm",
    -- load your default shell before starting the task
    use_shell = false,
    -- overwrite the default toggleterm "direction" parameter
    direction = nil,
    -- overwrite the default toggleterm "highlights" parameter
    highlights = nil,
    -- overwrite the default toggleterm "auto_scroll" parameter
    auto_scroll = nil,
    -- have the toggleterm window close and delete the terminal buffer
    -- automatically after the task exits
    close_on_exit = false,
    -- have the toggleterm window close without deleting the terminal buffer
    -- automatically after the task exits
    -- can be "never, "success", or "always". "success" will close the window
    -- only if the exit code is 0.
    quit_on_exit = "never",
    -- open the toggleterm window when a task starts
    open_on_start = true,
    -- mirrors the toggleterm "hidden" parameter, and keeps the task from
    -- being rendered in the toggleable window
    hidden = false,
    -- command to run when the terminal is created. Combine with `use_shell`
    -- to run a terminal command before starting the task
    on_create = nil,
  },
})




-- Convert the cwd to a simple file name
local function get_cwd_as_name()
  local dir = vim.fn.getcwd(0)
  return dir:gsub("[^A-Za-z0-9]", "_")
end
require("auto-session").setup({
  pre_save_cmds = {
    function()
      overseer.save_task_bundle(
        get_cwd_as_name(),
        -- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
        -- pass in the results if you want to save specific tasks.
        nil,
        { on_conflict = "overwrite" } -- Overwrite existing bundle, if any
      )
    end,
  },
  -- Optionally get rid of all previous tasks when restoring a session
  pre_restore_cmds = {
    function()
      for _, task in ipairs(overseer.list_tasks({})) do
        task:dispose(true)
      end
    end,
  },
  post_restore_cmds = {
    function()
      overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
    end,
  },
})


