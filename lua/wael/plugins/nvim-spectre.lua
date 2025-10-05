return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>S",
			function()
				require("spectre").toggle()
			end,
			desc = "Toggle Spectre (Search & Replace)",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search current word",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual()
			end,
			mode = "v",
			desc = "Search current selection",
		},
		{
			"<leader>sp",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Search in current file",
		},
	},
	opts = {
		default = {
			find = {
				cmd = "rg",
				options = { "ignore-case" },
			},
			replace = {
				cmd = "sed",
			},
		},
	},
}
