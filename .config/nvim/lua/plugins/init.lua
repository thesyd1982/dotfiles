return {
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-fugitive" },
	{ "ThePrimeagen/vim-be-good" },
	{ "wakatime/vim-wakatime" },
	{ "mattn/emmet-vim" },
	{ "norcalli/nvim-colorizer.lua" },
	{ "sbdchd/neoformat" },
	{ "kshenoy/vim-signature" },
	{ "xiyaowong/transparent.nvim" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	{ "windwp/nvim-autopairs" },
	{ "windwp/nvim-ts-autotag" },

	{ "maxmellon/vim-jsx-pretty" },
	{ "leafgarland/typescript-vim" },
	{ "peitalin/vim-jsx-typescript" },
	{ "pangloss/vim-javascript" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ "mitchellh/tree-sitter-proto" },
}
