local cfg = {
	window = {
		width = 100,
		options = {},
	},
}
local z1 = function()
	require("zen-mode").setup({ cfg })
	require("zen-mode").toggle()
	vim.wo.wrap = false
	vim.wo.number = true
	vim.wo.rnu = true
end
-- local z2 = function()
--   require("zen-mode").setup({ cfg })
--   require("zen-mode").toggle()
--   vim.wo.wrap = false
--   vim.wo.number = false
--   vim.wo.rnu = false
--   vim.opt.colorcolumn = "12"
-- end

return {
	"folke/zen-mode.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>fz",
			function()
				z1()
			end,
			desc = "[F]ocus [Z]enMode",
		},
		-- {
		--   "<leader>uzZ",
		--   function()
		--     z2()
		--   end,
		--   desc = "ZenMode2",
		-- },
	},
}
