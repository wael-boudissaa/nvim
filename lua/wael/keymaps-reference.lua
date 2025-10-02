-- Keymap Reference - Document all your keymaps here
local M = {}

M.keymaps = {
  -- Copilot Agent
  ["<leader>ca*"] = "Copilot Agent commands",
  -- LSP
  ["<leader>l*"] = "LSP commands", 
  -- File operations
  ["<leader>f*"] = "File/Find operations",
  -- Git
  ["<leader>h*"] = "Git hunks",
  -- etc...
}

return M