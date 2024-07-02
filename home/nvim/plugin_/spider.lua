require("spider").setup {
	skipInsignificantPunctuation = true,
	consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
	subwordMovement = true,
	customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
}

vim.keymap.set(
	{ "n", "o", "x" },
	"w",
	function() require('spider').motion('w') end,
	{ desc = "Spider-w" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"e",
	function() require('spider').motion('e') end,
	{ desc = "Spider-e" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"b",
	function() require('spider').motion('b') end,
	{ desc = "Spider-b" }
)


