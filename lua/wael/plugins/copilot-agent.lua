return {
  -- GitHub Copilot Agent - Enhanced with Agent capabilities (no OpenAI API needed)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" }, -- for file picker
    },
    build = "make tiktoken",
    config = function()
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        debug = false,
        -- Use GitHub Copilot models (no OpenAI API key needed)
        model = "gpt-4o", 
        auto_follow_cursor = false,
        show_help = true,
        question_header = "## 🤔 User ",
        answer_header = "## 🤖 GitHub Copilot Agent ",
        error_header = "## ❌ Error ",
        separator = " ",
        
        -- Enable agent-like features with GitHub Copilot
        context = "buffers", -- Use all open buffers as context
        
        window = {
          layout = "float",
          width = 0.8,
          height = 0.8,
          relative = "editor",
        },

        mappings = {
          complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
          },
          close = {
            normal = "q",
            insert = "<C-c>"
          },
          reset = {
            normal = "<C-r>",
            insert = "<C-r>"
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-s>",
          },
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>"
          },
          yank_diff = {
            normal = "gy",
            register = '"',
          },
          show_diff = {
            normal = "gd"
          },
          show_system_prompt = {
            normal = "gp"
          },
          show_user_selection = {
            normal = "gs"
          },
        },

        -- Custom prompts for agent behavior
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
          },
          Review = {
            prompt = "/COPILOT_REVIEW Review the selected code.",
            callback = function(response, source)
              -- Custom callback for review actions
            end,
          },
          Fix = {
            prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
          },
          Optimize = {
            prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
          },
          Tests = {
            prompt = "/COPILOT_GENERATE Please generate tests for my code.",
          },
          FixDiagnostic = {
            prompt = "Please assist with the following diagnostic issue in file:",
            selection = select.diagnostics,
          },
          Commit = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit and write it in present tense.",
            selection = select.gitdiff,
          },
          CommitStaged = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit and write it in present tense.",
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
          -- Agent prompts that can modify files
          Agent = {
            prompt = "🤖 Act as my GitHub Copilot coding agent. You can modify files directly. When I ask you to make changes, provide the exact code changes I need and I'll apply them using <C-y>.",
          },
          ModifyFile = {
            prompt = "/COPILOT_GENERATE I need you to modify this file. Please provide the complete updated code with the changes I requested. Format it so I can easily apply it with <C-y>.",
          },
          CreateFile = {
            prompt = "/COPILOT_GENERATE Create a new file with the specifications I provide. Give me the complete file content.",
          },
          RefactorFile = {
            prompt = "/COPILOT_GENERATE Refactor this entire file according to my requirements. Provide the complete refactored code.",
          },
          AddFeature = {
            prompt = "/COPILOT_GENERATE Add the requested feature to this code. Provide the complete updated file with the new feature integrated.",
          },
        },
      })

      -- Enhanced agent functions that can modify files
      local function agent_modify_file(action_type, custom_prompt)
        local current_file = vim.fn.expand("%:p")
        local filename = vim.fn.expand("%:t")
        local filetype = vim.bo.filetype
        
        if current_file == "" then
          vim.notify("No file is currently open", vim.log.levels.WARN)
          return
        end
        
        local context_prompt = string.format([[
🤖 **AGENT MODE - FILE MODIFICATION**

**Current File:** `%s`
**File Type:** `%s`
**Action:** %s

%s

**Instructions:**
1. Analyze the current file content
2. Make the requested changes
3. Provide the COMPLETE updated file content
4. I'll review and apply changes with <C-y>

**Current File Content:**
]], filename, filetype, action_type, custom_prompt or "")
        
        require("CopilotChat").ask(context_prompt, {
          selection = require("CopilotChat.select").buffer
        })
      end

      local function agent_create_file(custom_prompt)
        local input_filename = vim.fn.input("New file name: ")
        if input_filename == "" then
          vim.notify("File name cannot be empty", vim.log.levels.WARN)
          return
        end
        
        local create_prompt = string.format([[
🤖 **AGENT MODE - FILE CREATION**

**New File:** `%s`
**Request:** %s

**Instructions:**
1. Create a complete file with the requested content
2. Include proper file structure, imports, and best practices
3. Provide the COMPLETE file content
4. I'll create the file and apply the content

**File Content:**
]], input_filename, custom_prompt or "Create a new file")
        
        -- Create new buffer for the file
        vim.cmd("enew")
        vim.cmd("file " .. input_filename)
        
        require("CopilotChat").ask(create_prompt)
      end

      local function agent_workspace_analyze()
        local cwd = vim.fn.getcwd()
        local files = vim.fn.glob(cwd .. "/**/*", false, true)
        local project_files = {}

        -- Filter to common code files
        local extensions = { ".lua", ".js", ".ts", ".py", ".go", ".cpp", ".c", ".java", ".html", ".css", ".md" }
        for _, file in ipairs(files) do
          for _, ext in ipairs(extensions) do
            if file:match(ext .. "$") then
              -- Fix: always insert as a value, not as a position
              local relfile = file:gsub("^" .. vim.pesc(cwd .. "/"), "")
              table.insert(project_files, relfile)
              break
            end
          end
        end

        local workspace_prompt = string.format([[
🤖 **AGENT MODE - WORKSPACE ANALYSIS**

**Current Workspace:** `%s`
**Project Files Found:**
%s

**Instructions:**
1. Analyze the project structure
2. Identify patterns, technologies, and architecture
3. Suggest improvements or answer questions about the codebase
4. I can open specific files for you to modify

**What would you like me to help you with in this workspace?**
]], cwd, table.concat(project_files, "\n"))

        require("CopilotChat").ask(workspace_prompt)
      end

      -- Make functions available globally
      _G.agent_modify_file = agent_modify_file
      _G.agent_create_file = agent_create_file
      _G.agent_workspace_analyze = agent_workspace_analyze
    end,
    
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<CR>", desc = "💬 Open Copilot Chat" },
      {
        "<leader>cv",
        function()
          local input = vim.fn.input("Agent action: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "🤖 Copilot Agent Action (ask agent to do something)",
      },
      
      -- File modification agents (like VS Code extension)
      {
        "<leader>cam",
        function()
          local action = vim.fn.input("What should I modify in this file? ")
          if action ~= "" then
            _G.agent_modify_file("MODIFY FILE", action)
          end
        end,
        desc = "🛠️ Agent - Modify Current File",
      },
      
      {
        "<leader>caf",
        function()
          local feature = vim.fn.input("What feature should I add? ")
          if feature ~= "" then
            _G.agent_modify_file("ADD FEATURE", feature)
          end
        end,
        desc = "✨ Agent - Add Feature to File",
      },
      
      {
        "<leader>car",
        function()
          _G.agent_modify_file("REFACTOR", "Refactor this code to improve readability, performance, and maintainability")
        end,
        desc = "♻️ Agent - Refactor Current File",
      },
      
      {
        "<leader>cab",
        function()
          local bug = vim.fn.input("Describe the bug to fix: ")
          if bug ~= "" then
            _G.agent_modify_file("FIX BUG", bug)
          end
        end,
        desc = "🐛 Agent - Fix Bug in File",
      },
      
      {
        "<leader>cac",
        function()
          local spec = vim.fn.input("File specification: ")
          if spec ~= "" then
            _G.agent_create_file(spec)
          end
        end,
        desc = "📄 Agent - Create New File",
      },
      
      {
        "<leader>caw",
        function()
          _G.agent_workspace_analyze()
        end,
        desc = "🏗️ Agent - Analyze Workspace",
      },
      
      -- Original agent actions (FIXED KEYMAPS)
      { "<leader>cao", "<cmd>CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "⚡ Agent - Optimize Selection" },
      { "<leader>cad", "<cmd>CopilotChatDocs<CR>", mode = { "n", "v" }, desc = "📚 Agent - Add Documentation" },
      { "<leader>cat", "<cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "🧪 Agent - Generate Tests" }, -- KEPT this one
      { "<leader>cae", "<cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "💡 Agent - Explain Code" }, -- CHANGED: cax -> cae
      
      -- Quick actions
      {
        "<leader>caq",
        function()
          local input = vim.fn.input("Quick Agent Chat: ")
          if input ~= "" then
            require("CopilotChat").ask("🤖 " .. input, { 
              selection = require("CopilotChat.select").buffer 
            })
          end
        end,
        desc = "💬 Agent - Quick Chat",
      },
      
      -- Multiple files agent
      {
        "<leader>caM",
        function()
          local action = vim.fn.input("What should I do across multiple files? ")
          if action ~= "" then
            require("CopilotChat").ask(string.format([[
🤖 **MULTI-FILE AGENT MODE**

**Task:** %s

**Context:** I have access to all open buffers. Please:
1. Analyze all relevant files
2. Suggest changes across multiple files
3. Provide specific modifications for each file
4. I'll apply changes file by file using <C-y>

**Instructions:** Tell me which files to modify and how.
]], action), {
              selection = require("CopilotChat.select").buffer
            })
          end
        end,
        desc = "🗂️ Agent - Multi-file Modifications",
      },
    },
  },
}
