return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = {
      "CopilotChat",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatFix",
      "CopilotChatTests",
    },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- Required for token handling on Unix
    opts = {
      debug = false, -- Set true for verbose logs
      window = {
        layout = "float", -- 'vertical', 'horizontal', or 'float'
        width = 0.6,
        height = 0.7,
      },
      mappings = {
        submit_prompt = "<CR>",
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<CR>", desc = "Start Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain selected code" },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix code with AI" },
      { "<leader>ct", "<cmd>CopilotChatTests<CR>", desc = "Generate tests with AI" },
      { "<leader>cx", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
    },
  },
}
