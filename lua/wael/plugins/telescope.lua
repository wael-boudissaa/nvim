return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Check if ripgrep is installed (for live_grep)
    if vim.fn.executable("rg") ~= 1 then
      vim.notify("Telescope: 'rg' (ripgrep) is not installed. live_grep will not work.", vim.log.levels.ERROR)
    end

    telescope.setup({
      defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = " ",
        path_display = { "smart" },
        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_width = 0.6 },
          vertical = { preview_height = 0.7 },
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<ESC>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Load extensions
    telescope.load_extension("fzf")

    -- Load todo-comments integration
    require("todo-comments").setup({})
    telescope.load_extension("todo-comments")

    -- Set keymaps
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "Telescope: " }

    keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
    keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recently opened files" })
    keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Search string in project" })
    keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
    keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODO comments" })
  end,
}
