return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = false,
    priority = 100, -- make sure this loads early
    dependencies = {
        -- LSP Support
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
        -- Dart/Flutter tools
        'akinsho/flutter-tools.nvim',
    },
    config = function()
        -- Set up diagnostic signs
        local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- Set up Mason first
        require('mason').setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        -- Configure language servers to install
        local servers = {
            -- Go
            'gopls',
            'golangci_lint_ls',
            -- Web development
            'html',
            'cssls',
            'tailwindcss',
            'svelte',
            'graphql',
            'emmet_ls',
            'ts_ls',

            'prismals',
            -- Other languages
            'lua_ls',
            'pyright',
            'clangd',
            -- Dart is handled by flutter-tools
        }

        -- Configure tools to install
        local tools = {
            -- Go tools
            'golangci-lint',
            'gopls',
            -- Formatters
            'prettier',
            'stylua',
            -- 'isort',
            -- 'black',
            -- Linters
            -- 'pylint',
            'eslint_d',
        }

        -- Initialize lsp-zero WITHOUT preset
        local lsp = require('lsp-zero')

        -- Get capabilities from cmp-nvim-lsp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Set up mason-tool-installer
        require('mason-tool-installer').setup({
            ensure_installed = tools,
            auto_update = false,
            run_on_start = true,
        })

        -- Define on_attach function for keymaps
        local function on_attach(client, bufnr)
            local opts = { buffer = bufnr, silent = true, noremap = true }

            -- Navigation
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
            vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

            vim.keymap.set("n", "<leader>cA", function()
                local params = vim.lsp.util.make_range_params()
                params.range = {
                    start = { line = 0, character = 0 },
                    ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 }
                }
                vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, actions)
                    if err then return end
                    vim.lsp.util.show_code_actions(actions)
                end)
            end, opts)
            -- Code actions
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set({ "n", "v" }, "<leader>cv", function() vim.lsp.buf.code_action() end, opts)

            -- Diagnostics
            vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end, opts)

            -- Format
            vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)

            -- If telescope is available, set up telescope-based keymaps
            local has_telescope, telescope = pcall(require, "telescope.builtin")
            if has_telescope then
                vim.keymap.set("n", "gR", function() telescope.lsp_references() end, opts)
                vim.keymap.set("n", "<leader>D", function() telescope.diagnostics({ bufnr = 0 }) end, opts)
            end
        end

        -- Update mason-lspconfig handlers to use on_attach
        require('mason-lspconfig').setup({
            ensure_installed = servers,
            automatic_enable = false,
            handlers = {
                -- Default handler
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
                -- Skip gopls in mason handlers (configured explicitly later since it's installed outside Mason)
                ['gopls'] = function() end,
                -- Custom handler for lua_ls
                ['lua_ls'] = function()
                    require('lspconfig').lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
                -- Custom handler for tailwindcss
                ['tailwindcss'] = function()
                    require('lspconfig').tailwindcss.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = {
                            "html", "css", "scss", "javascript", "javascriptreact",
                            "typescript", "typescriptreact", "svelte", "vue",
                        },
                        init_options = {
                            userLanguages = {
                                eelixir = "html", eruby = "html", heex = "html",
                                svelte = "html", twig = "html",
                            },
                        },
                        settings = {
                            tailwindCSS = {
                                experimental = {
                                    classRegex = {
                                        "tw`([^`]*)", "tw=\"([^\"]*)", "tw={\"([^\"}]*)",
                                        "tw\\.\\w+`([^`]*)", "class(Name)?=\"([^\"]*)",
                                        "class(Name)?={`([^`}]+)`",
                                    }
                                },
                                validate = true,
                                lint = {
                                    cssConflict = "warning",
                                    invalidApply = "error",
                                    invalidScreen = "error",
                                    invalidVariant = "error",
                                    invalidConfigPath = "error",
                                    invalidTailwindDirective = "error",
                                    recommendedVariantOrder = "warning",
                                },
                            }
                        },
                    })
                end,
            },
        })

        -- Set up Dart/Flutter support via flutter-tools
        require('flutter-tools').setup({
            lsp = {
                on_attach = function(client, bufnr)
                    -- Call our on_attach function
                    on_attach(client, bufnr)

                    -- Flutter-specific keymaps
                    local opts = { buffer = bufnr, silent = true, noremap = true }
                    vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", opts)
                    vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>", opts)
                    vim.keymap.set("n", "<leader>fe", ":FlutterEmulators<CR>", opts)
                    vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", opts)
                end,
                capabilities = capabilities,
            },
            debugger = {
                enabled = true,
                run_via_dap = true,
            },
            flutter_path = os.getenv("FLUTTER_HOME") or nil,
            widget_guides = {
                enabled = true,
            },
        })

        -- Explicitly setup gopls (since it's installed outside Mason)
        require('lspconfig').gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { vim.fn.expand("~/go/bin/gopls") },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = require('lspconfig').util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })

        -- Configure diagnostics appearance
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
