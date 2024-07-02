return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"numToStr/Comment.nvim", -- Add Comment.nvim as a dependency
	},
	config = function()
		-- Import todo-comments plugin
		local todo_comments = require("todo-comments")

		-- Set keymaps for todo-comments
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "Next todo comment" })

		keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "Previous todo comment" })

		-- Setup todo-comments
		todo_comments.setup()

		-- Import Comment.nvim plugin
		require("Comment").setup()

		-- Set keymaps for commenting
		keymap.set(
			"n",
			"<leader>/",
			":lua require('Comment.api').toggle.linewise.current()<CR>",
			{ noremap = true, silent = true, desc = "Comment/uncomment line" }
		)
		keymap.set(
			"x",
			"<leader>/",
			":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			{ noremap = true, silent = true, desc = "Comment/uncomment selection" }
		)
	end,
}
