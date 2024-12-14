-- Set leader key to space
vim.env.PATH = vim.env.PATH .. ':/home/wael-boudissa/.npm-global/bin'
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness
local harpoon = "harpoon.ui"
vim.opt.encoding = "utf-8"
keymap.set("n", "<leader>y", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")
keymap.set("n", "<leader>t", ":lua require('harpoon.mark').add_file()<CR>")
keymap.set("n", "m", ":lua require('harpoon.ui').nav_next()<CR>")
keymap.set("n", "M", ":lua require('harpoon.ui').nav_prev()<CR>")
keymap.set("n", "<C-o>", "o<ESC>")
keymap.set("n", "<C-p>", "<C-o>")
keymap.set("n", "<C-n>", "ddk")

vim.o.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.cmd([[
    augroup MyColors
        autocmd!
        autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
    augroup END
]])

keymap.set("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "format files" })

vim.keymap.set("n", "<Leader>rr", ":GCompileRunAndExit<CR>")

-- Move visual selection
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- General Keymaps
-- Use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("v", "<CR>", "<ESC>", { desc = "Exit visula mode with Enter" })
keymap.set("i", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
keymap.set("i", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
keymap.set("i", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
keymap.set("i", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window Up" })
vim.opt.undofile = true

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

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

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
-- Function to compile and run the current C++ file
function _CompileAndRun()
	-- Get the current file name without extension and the file type
	local file = vim.fn.expand("%:t:r")
	local filetype = vim.bo.filetype

	-- Determine the compile and run commands based on the file type
	local compile_cmd, run_cmd

	if filetype == "cpp" then
		compile_cmd = "g++ -o " .. file .. " " .. vim.fn.expand("%")
		run_cmd = "./" .. file
	elseif filetype == "go" then
		compile_cmd = "go run " .. vim.fn.expand("%")
		run_cmd = "" -- No need to run a separate command for Go since `go run` also executes
	else
		print("Unsupported file type: " .. filetype)
		return
	end

	-- Compile the file
	local compile_output = vim.fn.system(compile_cmd)

	-- Check if compilation was successful for C++
	if filetype == "cpp" and vim.v.shell_error ~= 0 then
		print("Compilation failed. Check the output for details.")
		print(compile_output)
		return
	end

	-- Run the executable in a split or in the current terminal
	if filetype == "cpp" then
		vim.cmd("split | term " .. run_cmd)
	elseif filetype == "go" then
		vim.cmd("split | term " .. compile_cmd)
	end
end

-- Map the function to a key (e.g., <leader>eu)
vim.api.nvim_set_keymap("n", "<leader>eu", ":w<CR> :lua _CompileAndRun()<CR>", { noremap = true, silent = true })
