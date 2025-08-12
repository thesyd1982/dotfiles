return {

	"folke/twilight.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>ft",
			mode = { "n", "x" },
			":Twilight<CR>",
			desc = "[F]ocus [T]wilight",
		},
	},
}
