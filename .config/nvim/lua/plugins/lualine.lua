return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		-- local lazy_status = require("lazy.status")
		local colors = {
			blue = "#65d1ff",
			green = "#3effdc",
			violet = "#ff61ef",
			yellow = "#ffda7b",
			red = "#ff4a4a",
			fg = "#c3cccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
			none = "NONE",
		}
		local my_lualine_theme = {
			statusline = { bg = colors.none },
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.none, fg = colors.fg },
				c = { bg = colors.none, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.none, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
		}
		lualine.setup({
			options = { theme = my_lualine_theme, component_separators = "", globalstatus = false },
			sections = {
				-- lualine_x = {
				-- 	{
				-- 		lazy_status.updates,
				-- 		cond = lazy_status.has_updates,
				-- 		color = { fg = "#ff9e64" },
				-- 	},
				-- 	{ "encoding" },
				-- 	{ "fileformat" },
				-- 	{ "filetype" },
				-- },
				-- lualine_c = { "%=", "%t%m", "%2p" },
				lualine_c = {
					"%=",
					"data",
					"require'lsp-status'.status()",
				},
				lualine_x = {
					{ "filename", shorten = 5 },
					"encoding",
					"fileformat",
					{
						"filetype",
						colored = true, -- Displays filetype icon in color if set to true
						icon_only = true, -- Display only an icon for filetype
						-- icon = { align = "right" }, -- Display filetype icon on the right hand side
						-- icon =    {'X', align='right'}
						-- Icon string ^ in table is ignored in filetype component
					},
				},
			},
		})
	end,
}
