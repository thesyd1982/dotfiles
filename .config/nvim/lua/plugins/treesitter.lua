return {
	"nvim-treesitter/nvim-treesitter",

	build = ":TSUpdate",
	dependencies = {
		"vrischmann/tree-sitter-templ",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = function()
				-- When in diff mode, we want to use the default
				-- vim text objects c & C instead of the treesitter ones.
				local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
				local configs = require("nvim-treesitter.configs")
				for name, fn in pairs(move) do
					if name:find("goto") == 1 then
						move[name] = function(q, ...)
							if vim.wo.diff then
								local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
								for key, query in pairs(config or {}) do
									if q == query and key:find("[%]%[][cC]") then
										vim.cmd("normal! " .. key)
										return
									end
								end
							end
							return fn(q, ...)
						end
					end
				end
			end,
		},
	},
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	keys = {
		{ "<c-space>", desc = "Increment Selection" },
		{ "<bs>", desc = "Decrement Selection", mode = "x" },
	},
	opts = {
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"elixir",
			"heex",
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"html",
			"markdown_inline",
			"markdown",
			"cpp",
			"rust",
			"typescript",
			"tmux",
			"dockerfile",
			"bash",
			"jsdoc",
			"json",
			"jsonc",
			"luadoc",
			"luap",
			"regex",
			"toml",
			"python",
			"php",
			"rust",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
			"sql",
			"sqlite",
			"templ",
			"tmpl",
			"gotmpl",
			"go",
			"gotexttmpl",
			"sql",
			"java",
			"kotlin",
			"prisma",
			"yml",
		},
		sync_install = false,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		indent = { enable = true },

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-D>",
				node_incremental = "<C-D>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		textobjects = {
			move = {
				enable = true,
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
			},
		},
	},
}
