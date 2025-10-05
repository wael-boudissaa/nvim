-- LazyGit integration using toggleterm (primary method)
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{
			"<leader>lg",
			function()
				local Terminal = require("toggleterm.terminal").Terminal
				local lazygit = Terminal:new({
					cmd = "lazygit",
					hidden = true,
					direction = "float",
					float_opts = {
						border = "curved",
						width = function()
							return math.floor(vim.o.columns * 0.9)
						end,
						height = function()
							return math.floor(vim.o.lines * 0.9)
						end,
					},
					on_open = function(term)
						vim.cmd("startinsert!")
						vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
					end,
					on_close = function()
						vim.cmd("startinsert!")
					end,
				})
				lazygit:toggle()
			end,
			desc = "Open LazyGit",
		},
	},
	opts = {
		size = 20,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_terminals = true,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
	},
}
