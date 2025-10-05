return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ █████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "📄  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC ee", "📁  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "🔍 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "🔎  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "🔄  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "❌ > Quit NVIM", "<cmd>qa<CR>"),
		}
		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		-- Close alpha automatically when opening a file or directory
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				-- Close alpha when any real file is opened
				vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
					callback = function()
						local buf = vim.api.nvim_get_current_buf()
						local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
						local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

						-- Close alpha if we open a real file (not alpha, not special buffer)
						if filetype ~= "alpha" and buftype ~= "nofile" then
							vim.cmd("silent! close | buffer " .. buf)
						end
					end,
				})
			end,
		})
	end,
}
