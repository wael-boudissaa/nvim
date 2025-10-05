return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>c", group = "Copilot" },
      { "<leader>ca", group = "Copilot Agent" },
      { "<leader>l", group = "LSP" },
      { "<leader>f", group = "Find/Files" },
      { "<leader>h", group = "Git Hunks" },
      { "<leader>s", group = "Splits/Search/Spectre" },
      { "<leader>x", group = "Trouble/Diagnostics" },
      { "<leader>q", group = "Session" },
    },
  },
}
