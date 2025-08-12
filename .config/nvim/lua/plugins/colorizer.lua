return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	ft = { "css", "scss", "html", "javascript", "typescript", "typescriptreact", "lua" },
	config = true,
	-- keys ={{"<leader>",mode = {"n","x"},":ColorizerToggle<CR>",{desc="Toggle colorizer"}}}
}
