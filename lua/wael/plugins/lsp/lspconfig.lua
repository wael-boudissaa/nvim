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

    -- Set up mason-lspconfig
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    -- Set up mason-tool-installer
    require('mason-tool-installer').setup({
      ensure_installed = tools,
      auto_update = false,
      run_on_start = true,
    })

    -- Initialize lsp-zero
    local lsp = require('lsp-zero').preset({
      name = 'minimal',
      set_lsp_keymaps = true,
      manage_nvim_cmp = true,
      suggest_lsp_servers = false,
    })

    -- Add custom keymaps for LSP
    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr, silent = true, noremap = true }
      
      -- Navigation
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
      vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      
      -- Code actions
      vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set({"n", "v"}, "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
      
      -- Diagnostics
      vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end, opts)
      
      -- Format
      vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, opts)
      
      -- If telescope is available, set up telescope-based keymaps
      local has_telescope, telescope = pcall(require, "telescope.builtin")
      if has_telescope then
        vim.keymap.set("n", "gR", function() telescope.lsp_references() end, opts)
        vim.keymap.set("n", "<leader>D", function() telescope.diagnostics({ bufnr = 0 }) end, opts)
      end
    end)

    -- Configure specific language servers
    
    -- gopls (Go)
    lsp.configure('gopls', {
      cmd = { "gopls" },
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
    
    -- golangci-lint
    lsp.configure('golangci_lint_ls', {
      filetypes = { "go", "gomod" },
      root_dir = require('lspconfig').util.root_pattern(".git", "go.mod"),
      init_options = {
        command = { 
          "golangci-lint", 
          "run", 
          "--output-format", 
          "json" 
        },
      },
    })
    
    -- lua_ls (Lua)
    lsp.configure('lua_ls', {
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

    -- Set up nvim-cmp
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    
    -- Load snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })

    -- Set up Dart/Flutter support via flutter-tools
    require('flutter-tools').setup({
      lsp = {
        on_attach = function(client, bufnr)
          -- Call lsp-zero's default on_attach function
          lsp.on_attach(client, bufnr)
          
          -- Flutter-specific keymaps
          local opts = { buffer = bufnr, silent = true, noremap = true }
          vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", opts)
          vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>", opts)
          vim.keymap.set("n", "<leader>fe", ":FlutterEmulators<CR>", opts)
          vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", opts)
        end,
        capabilities = lsp.get_capabilities(),
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

    -- Set up LSP
    lsp.setup()
    
    -- Configure diagnostics appearance (after lsp.setup())
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
