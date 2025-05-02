return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    -- Autotagging
    "windwp/nvim-ts-autotag",

    -- Autocompletion and snippets
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",

    -- Prisma syntax
    {
      "prisma/vim-prisma",
      ft = "prisma",
    },

    -- Dart and Flutter support
    {
      "dart-lang/dart-vim-plugin",
      ft = { "dart" },
    },
    {
      "akinsho/flutter-tools.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("flutter-tools").setup({
          lsp = {
            settings = {
              showTodos = true,
              completeFunctionCalls = true,
            },
          },
        })
      end,
    },
    {
      "natebosch/vim-lsc",
      ft = { "dart" },
    },
  },

  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = {
        enable = true,
        disable = {}, -- Do not disable Go or anything else unless necessary
        additional_vim_regex_highlighting = false, -- No mixed highlighting
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
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
        "cpp",
        "go",
        "dart",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
