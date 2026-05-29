local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
-- our picker function: colors
--
local res = vim.fn.system('nix-search-tv --indexes nixpkgs print')

function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
local opts = mysplit(res, "\n")

local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
        results = opts
      -- results = { "red", "green", "blue" }
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
colors()
