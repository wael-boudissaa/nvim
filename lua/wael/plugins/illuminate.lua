return {
  "RRethy/vim-illuminate",
  event = "VeryLazy", -- load when idle, not on startup
  config = function()
    require("illuminate").configure({
      delay = 120, -- Slightly slower to avoid flicker
      under_cursor = true, -- highlight word under cursor
      min_count_to_highlight = 2, -- ignore common keywords (e.g. "if")
      filetypes_denylist = {
        "NvimTree",
        "TelescopePrompt",
        "dashboard",
        "alpha",
        "lazy",
      },
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
    })

    -- Optional keymaps for navigating highlighted words
    vim.keymap.set("n", "<M-n>", require("illuminate").goto_next_reference, { desc = "Next reference" })
    vim.keymap.set("n", "<M-p>", require("illuminate").goto_prev_reference, { desc = "Previous reference" })
  end,
}
