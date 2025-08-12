return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = true,
	dependencies = {
		"rcarriga/nvim-notify",
		"MunifTanjim/nui.nvim",
	},

	opts = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- you can enable a preset for easier configuration
		routes = {
			{
				view = "notify",
				filter = { event = "msg_showmode" },
			},
		},
		presets = {
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		views = {
			-- Configuration du popup cmdline
			cmdline_popup = {
				position = {
					row = "40%",
					col = "50%",
				},
				size = {
					width = 60, -- Largeur de la fenêtre
					height = "auto", -- Hauteur automatique en fonction du contenu
				},
				-- Le champ de saisie s'étendra sur deux lignes si nécessaire
				win_options = {
					wrap = true, -- Permet de passer à la ligne automatiquement si le texte est trop long
					linebreak = true, -- Active le retour à la ligne
				},
			},
			-- Configuration du popupmenu
			popupmenu = {
				relative = "editor",
				position = {
					row = 8,
					col = "30%",
				},
				size = {
					width = 60,
					height = 10,
				},
				border = {
					style = "solid", -- Bordure solide (carrée)
					padding = { 1, 2 }, -- Ajuste la largeur de la bordure
				},
				win_options = {
					winhighlight = { Normal = "NormalFloat", FloatBorder = "DiagnosticInfo" },
				},
			},
		},
	},
}
