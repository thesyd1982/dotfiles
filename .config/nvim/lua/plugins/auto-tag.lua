return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	opts = {
		enable = true, -- Active le plugin
		filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "svelte", "php", "markdown" },
	},
	config = function(_, opts)
		require("nvim-ts-autotag").setup(opts)
	end,
}
