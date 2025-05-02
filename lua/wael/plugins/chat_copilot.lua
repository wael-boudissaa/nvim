return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", -- Use main branch as recommended
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
    build = "make tiktoken", -- Only needed on Mac/Linux
    opts = {
      debug = false,
      window = {
        layout = "float",
        width = 0.6,
        height = 0.7,
      },
      mappings = {
        submit_prompt = {
          normal = "<CR>",  -- Enter in normal mode
          insert = "<CR>",  -- Enter in insert mode
        },
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
