return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED
		require("config.aliases")
		Map("n", "<leader>ha", function()
			harpoon:list():append()
			print("Harpoon: file added!")
		end, { desc = "[H]arpoon [A]dd file" })
		Map("n", "<leader>ho", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [O]pen window" })

		Map("n", "<leader>h1", function()
			harpoon:list():select(1)
		end, { desc = "[H]arppon [1]st File" })
		Map("n", "<leader>h2", function()
			harpoon:list():select(2)
		end, { desc = "[H]arppon [2]nd File" })
		Map("n", "<leader>h3", function()
			harpoon:list():select(3)
		end, { desc = "[H]arppon [3]th File" })
		Map("n", "<leader>h4", function()
			harpoon:list():select(4)
		end, { desc = "[H]arppon [4]th File" })

		-- Toggle previous & next buffers stored within Harpoon list
		Map("n", "<C-p>", function()
			harpoon:list():prev()
		end, { desc = "[P]revious" })
		Map("n", "<C-n>", function()
			harpoon:list():next()
		end, { desc = "[N]ext" })
	end,
}
