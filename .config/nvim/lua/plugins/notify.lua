return {
	"rcarriga/nvim-notify",
	config = function()
		-- Charger et configurer notify avec la couleur de fond spécifiée
		local notify = require("notify")

		-- Ajouter un keybind pour fermer toutes les notifications
		vim.keymap.set("n", "<leader>nd", function()
			notify.dismiss({ silent = true, pending = true })
		end, { desc = "[D]ismiss [N]otifications" })
	end,

	opts = {
		level = 3,
		render = "minimal",
		timeout = 1000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.lines * 0.75)
		end,
	},
}
