return {
	"kdheepak/lazygit.nvim", -- Correct plugin name for LazyGit integration
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required dependency
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" }, -- Set keybinding
	},
}
