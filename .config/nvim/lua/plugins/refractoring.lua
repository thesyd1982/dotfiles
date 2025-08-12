return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	keys = {
		{ "<leader>re", mode = "x", ":Refactor extract ", desc = "[R]efactor [E]xtract " },
		{ "<leader>rf", mode = "x", ":Refactor extract_to_file ", desc = "[R]efactor Extract_to_[F]ile " },
		{ "<leader>rv", mode = "x", ":Refactor extract_var  ", desc = "[R]efactor Extract_[V]ar " },
		{ "<leader>riv", mode = "x", ":Refactor inline_var ", desc = "[R]efactor [I]nline [V]ar" },
		{ "<leader>rif", mode = "x", ":Refactor inline_func ", desc = "[R]efactor Inline [F]unc" },
		{ "<leader>rb", mode = "x", ":Refactor extract_block ", desc = "[R]efactor Extract [B]lock" },
		{
			"<leader>rbf",
			mode = "x",
			":Refactor extract_block_to_file ",
			desc = "[R]efactor Extract[B]lock to [F]ile",
		},
	},
}
