return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			delay = 100,
		})
	end,
}
