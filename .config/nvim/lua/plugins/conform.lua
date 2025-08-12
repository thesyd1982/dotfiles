return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			lua = { "stylua", "lua-format" },
			-- Conform can also run multiple formatters sequentially
			python = { "isort", "black" },
			json = { "prettierd", "prettier", "biome", stop_after_first = true },
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			javascript = { "prettierd", "prettier", stop_after_first = true },
			bash = { "shfmt" },
			go = { "gofmt" },
		},
		format_on_save = {
			top_after_first = true,
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		},
	},
}
