return {
	"nvim-treesitter/nvim-treesitter",
	"charlespascoe/vim-go-syntax",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		-- Existing dependencies
		"windwp/nvim-ts-autotag",
		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		"L3MON4D3/LuaSnip", -- Snippet engine
		"saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
		"rafamadriz/friendly-snippets", -- Snippet collection
		-- Prisma syntax highlighting
		{
			"prisma/vim-prisma",
			ft = "prisma", -- Load only for Prisma files
		},
		-- Add Flutter and Dart support
		{
			"dart-lang/dart-vim-plugin", -- Basic Dart syntax highlighting
			ft = { "dart" }, -- Load only for Dart files
		},
		{
			"akinsho/flutter-tools.nvim",
			dependencies = "nvim-lua/plenary.nvim",
			config = function()
				require("flutter-tools").setup({
					lsp = {
						-- Customize LSP settings for Dart/Flutter
						settings = {
							showTodos = true,
							completeFunctionCalls = true,
						},
					},
				})
			end,
		},
		{
			"natebosch/vim-lsc", -- Language Server Client (alternative to nvim-lspconfig)
			ft = { "dart" }, -- Load only for Dart files
		},
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")
		local golang = require("vim-go.syntax.go")

		golang.setup({
			go_highlight_function_calls = "Type",
			go_highlight_fields = 1,
			go_highlight_braces = 1,
			go_highlight_brackets = 1,
		})

		-- configure treesitter
		treesitter.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
				disable = { "go" }, -- disable highlight for Go
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma", -- Add Prisma parser (if supported by Treesitter)
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp", -- Add C++ parser
				"go", -- Add Go parser
				"dart", -- Add Dart parser
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					-- init_selection = "<C-space>",
					-- node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
