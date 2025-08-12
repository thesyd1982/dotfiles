-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("thesyd-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.sql", "*.sqlite" },
	command = "set filetype=sql",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	desc = "Fixe treesitter",
	callback = function()
		local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
		ts_update()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.templ",
	callback = function()
		vim.cmd("TSBufEnable highlight")
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.tmpl", "gotmpl", "gotexttmpl" },
	command = "set filetype=gotmpl",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.md",
	callback = function()
		vim.opt_local.spell = false
	end,
})
