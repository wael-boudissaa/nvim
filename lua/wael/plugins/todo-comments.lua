return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"numToStr/Comment.nvim",
		"JoosepAlviste/nvim-ts-context-commentstring", -- Add context-commentstring as a dependency
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
		local comment = require("Comment")

		-- Customize Comment.nvim for JSX
		comment.setup({
			pre_hook = function(ctx)
				-- Determine whether to use linewise or blockwise commentstring
				local U = require("Comment.utils")

				local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

				-- Determine the location where to calculate commentstring from
				local location = nil
				if ctx.ctype == U.ctype.blockwise then
					location = require("ts_context_commentstring.utils").get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
					location = require("ts_context_commentstring.utils").get_visual_start_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring({
					key = type,
					location = location,
				})
			end,
		})

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
