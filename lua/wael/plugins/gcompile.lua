return {
	"kutiny/gcompile.nvim",
	config = function()
		local mod = require("gcompile")
		mod.setup({
			split = "horizontal",
		})
	end,
}
