return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dotenv", lazy = true },
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_winwidth = 30
			vim.g.db_ui_show_help = 0
			vim.g.db_ui_use_nvim_notify = 1
			vim.g.db_ui_win_position = "left"
		end,
		keys = {
			{ "<leader>D", group = "󰆼 Db Tools" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = " DB UI Find buffer" },
			{ "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = " DB UI Last query infos" },
			{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = " DB UI Rename buffer" },
			{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = " DB UI Toggle" },
		},
	},
}
