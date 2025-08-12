return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		keys = {
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>c_", hidden = true },
			{ "<leader>e", group = "[E]xplorer" },
			{ "<leader>e_", hidden = true },
			{ "<leader>f", group = "[F]ocus" },
			{ "<leader>f_", hidden = true },
			{ "<leader>h", group = "[H]arpoon" },
			{ "<leader>h_", hidden = true },
			{ "<leader>l", group = "[L]azy" },
			{ "<leader>l_", hidden = true },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>r_", hidden = true },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>s_", hidden = true },
			{ "<leader>u", group = "[U]ndo Tree" },
			{ "<leader>u_", hidden = true },
		},
	},
}
