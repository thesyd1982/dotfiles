-- local util = require("lspconfig.util")
_G.eslint_enabled = true -- Flag global pour l'état d'activation d'ESLint

return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },

		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim" },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			{ "folke/neodev.nvim" },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("thesyd-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						require("config.aliases")
						Map("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					map("<leader>sds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					map(
						"<leader>sws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Hover documentation.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Goto Declaration.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Mapping pour activer/désactiver ESLint
					map("<leader>te", function()
						if _G.eslint_enabled then
							vim.cmd("LspStop eslint")
							print("ESLint désactivé")
						else
							vim.cmd("LspStart eslint")
							print("ESLint activé")
						end
						_G.eslint_enabled = not _G.eslint_enabled
					end, "[T]oggle [E]SLint")

					-- Autocommands for document highlighting.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- LSP servers and clients setup
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				bashls = { filetypes = { "sh", "bash", "zsh" } },
				clangd = { filetypes = { "c", "cpp", "objc", "objcpp" } },
				emmet_ls = {
					filetypes = {
						"gopls",
						-- "gotexttmpl",
						"templ",
						"template",
						"html",
						"css",
						"scss",
						"sass",
						"less",
						"php",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"gotmpl",
					},
				},
				gopls = { gofumpt = true },
				pyright = {},
				rust_analyzer = {},
				intelephense = {},
				cmake = {},
				html = { filetypes = { "html", "templ" } },
				templ = { filetypes = { "templ" } },
				biome = {},
				ts_ls = {
					settings = {
						javascript = {
							-- Disable type checking in JavaScript files
							implicitProjectConfig = {
								checkJs = false, -- Disable TypeScript checks in JavaScript
							},
						},
						typescript = {
							-- You can add any TypeScript-specific settings here if needed
						},
					},
				},
				lua_ls = {
					settings = {
						lua = {
							completion = { callsnippet = "replace" },
							hint = { enable = false },
						},
					},
				},
				sqlls = {},
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = { unknownAtRules = "ignore" },
						},
						scss = {
							validate = true,
							lint = { unknownAtRules = "ignore" },
						},
						less = {
							validate = true,
							lint = { unknownAtRules = "ignore" },
						},
					},
				},
				prismals = {},
				jsonls = {},
			}

			-- Install servers and tools.
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, { "stylua" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
