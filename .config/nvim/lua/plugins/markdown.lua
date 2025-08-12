return {
	"iamcco/markdown-preview.nvim",
	run = "cd app && yarn install", -- Assurez-vous d'avoir Yarn installé
	cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	config = function()
		vim.g.mkdp_auto_start = 1 -- Démarre automatiquement la prévisualisation
		vim.g.mkdp_open_to_the_world = 1 -- Ouvre dans le navigateur par défaut
	end,
}
