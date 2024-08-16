-- return {
-- 	"sainnhe/gruvbox-material",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- optionally configure and load the colorscheme
-- 		-- directly inside the plugin declaration.
-- 		vim.g.gruvbox_material_enable_italic = true
-- 		vim.cmd.colorscheme("gruvbox-material")
-- 	end,
-- }
-- return {
-- 	{
-- 		"rose-pine/neovim",
-- 		name = "rose-pine",
-- 		config = function()
-- 			require("rose-pine").setup({
-- 				variant = "auto", -- auto, main, moon, or dawn
-- 				dark_variant = "main", -- main, moon, or dawn
-- 				dim_inactive_windows = false,
-- 				extend_background_behind_borders = true,
--
-- 				enable = {
-- 					terminal = true,
-- 					legacy_highlights = true, -- improve compatibility for previous versions of neovim
-- 					migrations = true, -- handle deprecated options automatically
-- 				},
--
-- 				styles = {
-- 					bold = true,
-- 					italic = true,
-- 					transparency = false,
-- 				},
--
-- 				groups = {
-- 					border = "muted",
-- 					link = "iris",
-- 					panel = "surface",
--
-- 					error = "love",
-- 					hint = "iris",
-- 					info = "foam",
-- 					note = "pine",
-- 					todo = "rose",
-- 					warn = "gold",
--
-- 					git_add = "foam",
-- 					git_change = "rose",
-- 					git_delete = "love",
-- 					git_dirty = "rose",
-- 					git_ignore = "muted",
-- 					git_merge = "iris",
-- 					git_rename = "pine",
-- 					git_stage = "iris",
-- 					git_text = "rose",
-- 					git_untracked = "subtle",
--
-- 					h1 = "iris",
-- 					h2 = "foam",
-- 					h3 = "rose",
-- 					h4 = "gold",
-- 					h5 = "pine",
-- 					h6 = "foam",
-- 				},
--
-- 				highlight_groups = {
-- 					-- comment = { fg = "foam" },
-- 					-- vertsplit = { fg = "muted", bg = "muted" },
-- 				},
--
-- 				before_highlight = function(group, highlight, palette)
-- 					-- disable all undercurls
-- 					-- if highlight.undercurl then
-- 					--     highlight.undercurl = false
-- 					-- end
-- 					--
-- 					-- change palette colour
-- 					-- if highlight.fg == palette.pine then
-- 					--     highlight.fg = palette.foam
-- 					-- end
-- 				end,
-- 			})
--
-- 			-- vim.cmd("colorscheme rose-pine")
-- 			-- uncomment one of the following to use a specific variant
-- 			vim.cmd("colorscheme rose-pine-main")
-- 			-- vim.cmd("colorscheme rose-pine-moon")
-- 			-- vim.cmd("colorscheme rose-pine-dawn")
-- 		end,
-- 	},
-- }
--
-- -- default options:
-- setup must be called before loadingr
-- return {
-- 	"mofiqul/vscode.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- function to switch between light and dark themes
-- 		local function switch_vscode_theme()
-- 			if vim.o.background == "dark" then
-- 				vim.o.background = "light"
-- 				require("vscode").load("light")
-- 				print("switched to vscode light theme")
-- 			else
-- 				vim.o.background = "dark"
-- 				require("vscode").load("dark")
-- 				print("switched to vscode dark theme")
-- 			end
-- 		end
--
-- 		-- create a user command for switching themes
-- 		vim.api.nvim_create_user_command("switchvscodetheme", switch_vscode_theme, {})
--
-- 		-- optionally set a keybinding for switching themes
-- 		vim.api.nvim_set_keymap("n", "<leader>kt", ":switchvscodetheme<cr>", { noremap = true, silent = true })
--
-- 		-- load the initial theme
-- 		vim.o.background = "dark"
-- 		require("vscode").load("dark")
--
-- 		-- configure bufferline
-- 		-- require("bufferline").setup({
-- 		-- 	options = {
-- 		-- 		buffer_close_icon = "",
-- 		-- 		close_command = "bdelete %d",
-- 		-- 		close_icon = "",
-- 		-- 		indicator = {
-- 		-- 			style = "icon",
-- 		-- 			icon = " ",
-- 		-- 		},
-- 		-- 		left_trunc_marker = "",
-- 		-- 		modified_icon = "●",
-- 		-- 		offsets = { { filetype = "nvimtree", text = "explorer", text_align = "center" } },
-- 		-- 		right_mouse_command = "bdelete! %d",
-- 		-- 		right_trunc_marker = "",
-- 		-- 		show_close_icon = false,
-- 		-- 		show_tab_indicators = true,
-- 		-- 	},
-- 		-- 	highlights = {
-- 		-- 		fill = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "statuslinenc" },
-- 		-- 		},
-- 		-- 		background = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "statusline" },
-- 		-- 		},
-- 		-- 		buffer_visible = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "normal" },
-- 		-- 		},
-- 		-- 		buffer_selected = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "normal" },
-- 		-- 		},
-- 		-- 		separator = {
-- 		-- 			fg = { attribute = "bg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "statusline" },
-- 		-- 		},
-- 		-- 		separator_selected = {
-- 		-- 			fg = { attribute = "fg", highlight = "special" },
-- 		-- 			bg = { attribute = "bg", highlight = "normal" },
-- 		-- 		},
-- 		-- 		separator_visible = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "statuslinenc" },
-- 		-- 		},
-- 		-- 		close_button = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "statusline" },
-- 		-- 		},
-- 		-- 		close_button_selected = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "normal" },
-- 		-- 		},
-- 		-- 		close_button_visible = {
-- 		-- 			fg = { attribute = "fg", highlight = "normal" },
-- 		-- 			bg = { attribute = "bg", highlight = "normal" },
-- 		-- 		},
-- 		-- 	},
-- 		-- })
-- 	end,
-- }
--
-- return {
--
-- 	"olivercederborg/poimandres.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("poimandres").setup({
-- 			-- leave this setup function empty for default config
-- 			-- or refer to the configuration section
-- 			-- for configuration options
-- 		})
-- 	end,
--
-- 	-- optionally set the colorscheme within lazy config
-- 	init = function()
-- 		vim.cmd("colorscheme poimandres")
-- 	end,
-- }
--
-- return {
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		priority = 1000, -- make sure to load this before all the other start plugins
--
-- 		config = function()
-- 			local bg = "#282a36" -- A dark, muted purple-blue background
-- 			local bg_dark = "#1c1e26" -- A deeper almost black shade for darker areas
-- 			local bg_highlight = "#44475a" -- A soft grayish-blue for highlights
-- 			local bg_search = "#ff79c6" -- A vibrant pink for search highlights
-- 			local bg_visual = "#bd93f9" -- A lavender shade for visual mode
-- 			local fg = "#f8f8f2" -- A near-white color for foreground text
-- 			local fg_dark = "#e0e0e0" -- A light gray for secondary text
-- 			local fg_gutter = "#6272a4" -- A cool blue-gray for the gutter
-- 			local border = "#50fa7b" -- A bright, fresh green for the border
-- 			require("tokyonight").setup({
-- 				style = "night",
-- 				on_colors = function(colors)
-- 					colors.bg = bg
-- 					colors.bg_dark = bg_dark
-- 					colors.bg_float = bg_dark
-- 					colors.bg_highlight = bg_highlight
-- 					colors.bg_popup = bg_dark
-- 					colors.bg_search = bg_search
-- 					colors.bg_sidebar = bg_dark
-- 					colors.bg_statusline = bg_dark
-- 					colors.bg_visual = bg_visual
-- 					colors.border = border
-- 					colors.fg = fg
-- 					colors.fg_dark = fg_dark
-- 					colors.fg_float = fg
-- 					colors.fg_gutter = fg_gutter
-- 					colors.fg_sidebar = fg_dark
-- 				end,
-- 			})
-- 			-- load the colorscheme here
-- 			vim.cmd([[colorscheme tokyonight]])
-- 		end,
-- 	},
-- }
return {
	--
	"oxfist/night-owl.nvim",

	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		require("night-owl").setup()
		vim.cmd.colorscheme("night-owl")
	end,
}
