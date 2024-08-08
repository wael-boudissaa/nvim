return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			auto_install = true,
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					"tsserver",
					"html",
					"cssls",
					"tailwindcss",
					"svelte",
					"lua_ls",
					"graphql",
					"emmet_ls",
					"prismals",
					"pyright",
					"clangd",
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"isort",
					"black",
					"pylint",
					"eslint_d",
				},
			})
		end,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	-- Autocompletion

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local capabilities = cmp_nvim_lsp.default_capabilities()
			local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["svelte"] = function()
					lspconfig["svelte"].setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
				["graphql"] = function()
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["pyright"] = function()
					lspconfig["pyright"].setup({
						capabilities = capabilities,
					})
				end,
				["clangd"] = function()
					lspconfig["clangd"].setup({
						capabilities = capabilities,
						cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
						root_dir = lspconfig.util.root_pattern(".clangd", "compile_commands.json", ".git"),
						single_file_support = true,
					})
				end,
				["tailwindcss"] = function()
					lspconfig["tailwindcss"].setup({
						capabilities = capabilities,
					})
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local keymap = vim.keymap

					opts.desc = "Show LSP references"
					keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Go to definition"
					keymap.set("n", "gd", vim.lsp.buf.definition, opts)

					opts.desc = "Show LSP implementations"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Go to previous diagnostic"
					keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					opts.desc = "Go to next diagnostic"
					keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				end,
			})
		end,
	},
}
