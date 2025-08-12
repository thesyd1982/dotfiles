_G.copy_diagnostics_to_clipboard = function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		print("No dignostics on this line!")
		return
	end

	local messages = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(messages, diagnostic.message)
	end
	local result = table.concat(messages, "\n")

	vim.fn.setreg("+", result)
	print("Diagnostics copied to clipboard!")
end
return {}
