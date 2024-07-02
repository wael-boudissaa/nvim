-- Set leader key to space
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

vim.keymap.set("n", "<Leader>rr", ":GCompileRunAndExit<CR>")
-- Move visual selection
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- General Keymaps
-- Use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Center the screen after scrolling
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen after scrolling down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen after scrolling up" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Paste without yanking
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", function()
	if vim.fn.winnr("$") > 1 then
		vim.cmd("close")
	else
		print("Cannot close the last window")
	end
end, { desc = "Close current split" })
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", function()
	if vim.fn.winnr("$") > 1 then
		vim.cmd("close")
	else
		print("Cannot close the last window")
	end
end, { desc = "Close current split" })
keymap.set("n", "<leader>sn", "<C-w>w", { desc = "Cycle through split windows" })

keymap.set("n", "<leader>sy", "<C-w>W", { desc = "Cycle through split windows (horizontal)" })
-- Tab management
--  keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
--  keymap.set("n", "<leader>tx", close_tab, { desc = "Close current tab" })
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
--
--
--
--
--
