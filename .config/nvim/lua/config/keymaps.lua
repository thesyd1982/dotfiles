require("config.aliases")
-- Lazy
Map("n", "<leader>ll", ":Lazy<CR>", { desc = "Toggle Lazy" })
Map("n", "<leader>lp", ":Lazy load ", { desc = "Load Plugin" })
Map("n", "<leader>lr", ":Lazy reload ", { desc = "Reload Plugin" })
Map("n", "<leader>ls", ":Lazy sync ", { desc = "Lazy Sync" })

-- nohl
Map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "which_key_ignore" })
-- Explorer
Map("n", "<leader>er", vim.cmd.Ex, { desc = "[E]xplore [R]oot dir" })

-- greatest remap ever
Map("x", "<leader>p", [["_dP]], { desc = "which_key_ignore" })

Map("v", "J", ":m '>+1<CR>gv=gv", { desc = "which_key_ignore" })
Map("v", "K", ":m '<-2<CR>gv=gv", { desc = "which_key_ignore" })

-- next greatest remap ever : asbjornHaland
Map({ "n", "v" }, "<leader>y", [["+y]], { desc = "which_key_ignore" })
Map("n", "<leader>Y", [["+Y]], { desc = "which_key_ignore" })
Map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "which_key_ignore" })
Map("n", "<leader>cf", vim.lsp.buf.format, { desc = "[F]ormat code" })

Map({ "n", "v" }, "<leader>d", [["_d]], { desc = "which_key_ignore" })
Map({ "n", "x" }, "<leader>m", ":Matrix<CR>", { desc = "Matrix screen", silent = true })
Map("n", "<leader>rn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[R]efactor [E]xtractVa" })

Map("n", "<leader>cd", "<cmd>lua copy_diagnostics_to_clipboard()<CR>", { desc = "[C]opy inline [D]iagnostic" })
