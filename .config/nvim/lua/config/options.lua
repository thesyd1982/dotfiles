require("config.aliases")

-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable LazyVim auto format
vim.g.autoformat = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

Opt.autowrite = true -- Enable auto write
Opt.completeopt = "menu,menuone,noselect"
Opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
Opt.confirm = true -- Confirm to save changes before exiting modified buffer
Opt.cursorline = true -- Enable highlighting of the current line
Opt.expandtab = false -- Use spaces instead of tabs
-- Opt.formatoptions = "jcroqlnt" -- tcqj
Opt.grepformat = "%f:%l:%c:%m"
Opt.grepprg = "rg --vimgrep"
Opt.ignorecase = true -- Ignore case
Opt.inccommand = "nosplit" -- preview incremental substitute
Opt.laststatus = 3 -- global statusline
Opt.list = false -- Show some invisible characters (tabs...
Opt.mouse = "a" -- Enable mouse mode
Opt.number = true -- Print line number
Opt.pumblend = 10 -- Popup blend
Opt.pumheight = 10 -- Maximum number of entries in a popup
Opt.relativenumber = true -- Relative line numbers
Opt.scrolloff = 4 -- Lines of context
Opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
Opt.shiftround = true -- Round indent
Opt.shiftwidth = 2 -- Size of an indent
Opt.shortmess:append({ W = true, I = true, c = true, C = true })
Opt.showmode = false -- Dont show mode since we have a statusline
Opt.sidescrolloff = 8 -- Columns of context
Opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
Opt.smartcase = true -- Don't ignore case with capitals
Opt.smartindent = true -- Insert indents automatically

Opt.splitbelow = true -- Put new windows below current
Opt.splitkeep = "screen"
Opt.splitright = true -- Put new windows right of current
Opt.tabstop = 2 -- Number of spaces tabs count for
Opt.termguicolors = true -- True color support
if not vim.g.vscode then
	Opt.timeoutlen = 200 -- Lower than default (1000) to quickly trigger which-key
end
Opt.undofile = true
Opt.undolevels = 10000
Opt.updatetime = 200 -- Save swap file and trigger CursorHold
Opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
Opt.wildmode = "longest:full,full" -- Command-line completion mode
Opt.winminwidth = 5 -- Minimum window width
Opt.wrap = false -- Disable line wrap
Opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
Opt.nrformats = { "hex", "bin", "alpha" }
Opt.guicursor = ""
Opt.tabstop = 4
Opt.softtabstop = 4
Opt.shiftwidth = 4
Opt.expandtab = true
Opt.smartindent = true
Opt.wrap = false
Opt.swapfile = false
Opt.backup = false
Opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
Opt.undofile = true
Opt.hlsearch = true
Opt.incsearch = true
Opt.termguicolors = true
Opt.scrolloff = 8
Opt.signcolumn = "yes"
Opt.isfname:append("@-@")
Opt.updatetime = 50
Opt.colorcolumn = "100"
if vim.fn.has("nvim-0.10") == 1 then
	Opt.smoothscroll = true
end

-- Folding
Opt.foldlevel = 99

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.codeium_manual = true
vim.o.laststatus = 2
-- vim.filetype.add({ extension = { templ = "templ" } })
-- vim.filetype.add({
-- 	extension = {
-- 		gotmpl = "gotmpl",
-- 	},
-- 	pattern = {
-- 		[".*/templates/.*%.tpl"] = "helm",
-- 		[".*/templates/.*%.ya?ml"] = "helm",
-- 		["helmfile.*%.ya?ml"] = "helm",
-- 	},
-- })
Opt.spell = false
-- Opt.spelllang = { "en" }
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 50
