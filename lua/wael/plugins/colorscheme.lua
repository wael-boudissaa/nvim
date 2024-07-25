-- return {
-- 	"sainnhe/gruvbox-material",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- Optionally configure and load the colorscheme
-- 		-- directly inside the plugin declaration.
-- 		vim.g.gruvbox_material_enable_italic = true
-- 		vim.cmd.colorscheme("gruvbox-material")
-- 	end,
-- }
-- -- Default options:
-- setup must be called before loadingr
--NOTE: vs code code
--FIXEME:
--TEST:
-- V
return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Function to switch between light and dark themes
		local function switch_vscode_theme()
			if vim.o.background == "dark" then
				vim.o.background = "light"
				require("vscode").load("light")
				print("Switched to vscode light theme")
			else
				vim.o.background = "dark"
				require("vscode").load("dark")
				print("Switched to vscode dark theme")
			end
		end

		-- Create a user command for switching themes
		vim.api.nvim_create_user_command("SwitchVscodeTheme", switch_vscode_theme, {})

		-- Optionally set a keybinding for switching themes
		vim.api.nvim_set_keymap("n", "<leader>kt", ":SwitchVscodeTheme<CR>", { noremap = true, silent = true })

		-- Load the initial theme
		vim.o.background = "dark"
		require("vscode").load("dark")

		-- Configure bufferline
		-- require("bufferline").setup({
		-- 	options = {
		-- 		buffer_close_icon = "",
		-- 		close_command = "bdelete %d",
		-- 		close_icon = "",
		-- 		indicator = {
		-- 			style = "icon",
		-- 			icon = " ",
		-- 		},
		-- 		left_trunc_marker = "",
		-- 		modified_icon = "●",
		-- 		offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
		-- 		right_mouse_command = "bdelete! %d",
		-- 		right_trunc_marker = "",
		-- 		show_close_icon = false,
		-- 		show_tab_indicators = true,
		-- 	},
		-- 	highlights = {
		-- 		fill = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "StatusLineNC" },
		-- 		},
		-- 		background = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "StatusLine" },
		-- 		},
		-- 		buffer_visible = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "Normal" },
		-- 		},
		-- 		buffer_selected = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "Normal" },
		-- 		},
		-- 		separator = {
		-- 			fg = { attribute = "bg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "StatusLine" },
		-- 		},
		-- 		separator_selected = {
		-- 			fg = { attribute = "fg", highlight = "Special" },
		-- 			bg = { attribute = "bg", highlight = "Normal" },
		-- 		},
		-- 		separator_visible = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "StatusLineNC" },
		-- 		},
		-- 		close_button = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "StatusLine" },
		-- 		},
		-- 		close_button_selected = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "Normal" },
		-- 		},
		-- 		close_button_visible = {
		-- 			fg = { attribute = "fg", highlight = "Normal" },
		-- 			bg = { attribute = "bg", highlight = "Normal" },
		-- 		},
		-- 	},
		-- })
	end,
}

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
--
-- 	"oxfist/night-owl.nvim",
-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
-- 	priority = 1000, -- make sure to load this before all the other start plugins
-- 	config = function()
-- 		-- load the colorscheme here
-- 		require("night-owl").setup()
-- 		vim.cmd.colorscheme("night-owl")
-- 	end,
-- }
-- return {
--   {
--     "folke/tokyonight.nvim",
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       local bg = "#011628"
--       local bg_dark = "#011423"
--       local bg_highlight = "#143652"
--       local bg_search = "#0A64AC"
--       local bg_visual = "#275378"
--       local fg = "#CBE0F0"
--       local fg_dark = "#B4D0E9"
--       local fg_gutter = "#627E97"
--       local border = "#547998"
--
--       require("tokyonight").setup({
--         style = "night",
--         on_colors = function(colors)
--           colors.bg = bg
--           colors.bg_dark = bg_dark
--           colors.bg_float = bg_dark
--           colors.bg_highlight = bg_highlight
--           colors.bg_popup = bg_dark
--           colors.bg_search = bg_search
--           colors.bg_sidebar = bg_dark
--           colors.bg_statusline = bg_dark
--           colors.bg_visual = bg_visual
--           colors.border = border
--           colors.fg = fg
--           colors.fg_dark = fg_dark
--           colors.fg_float = fg
--           colors.fg_gutter = fg_gutter
--           colors.fg_sidebar = fg_dark
--         end,
--       })
--       -- load the colorscheme here
--       vim.cmd([[colorscheme tokyonight]])
--     end,
--   },
-- }
