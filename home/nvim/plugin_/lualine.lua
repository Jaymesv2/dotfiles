local overseer = require('overseer')

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', require('auto-session.lib').current_session_name},
    -- lualine_c = {require('auto-session.lib').current_session_name},
    lualine_x = {
        'encoding', 'fileformat', 'filetype',
        {
          "overseer",
          label = "", -- Prefix for task counts
          colored = true, -- Color the task icons and counts
          symbols = {
            [overseer.STATUS.FAILURE] = "F:",
            [overseer.STATUS.CANCELED] = "C:",
            [overseer.STATUS.SUCCESS] = "S:",
            [overseer.STATUS.RUNNING] = "R:",
          },
          unique = false, -- Unique-ify non-running task count by name
          name = nil, -- List of task names to search for
          name_not = false, -- When true, invert the name search
          status = nil, -- List of task statuses to display
          status_not = false, -- When true, invert the status search
        },
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
