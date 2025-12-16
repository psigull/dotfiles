-- lsp buffer-local keybinds
df.autocmd('LspAttach', { callback = function(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	local bufnr = args.buf

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	df.map('n', '<leader>lh', vim.lsp.buf.declaration, bufopts) -- header
	df.map('n', '<leader>ld', vim.lsp.buf.definition, bufopts) -- definition
	df.map('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
	df.map('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)

	-- use lsp folding if supported
	if client and client:supports_method('textDocument/foldingRange') then
		local win = vim.api.nvim_get_current_win()
		vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
	end
end})

-- enable all
for _, server_name in ipairs(df.lspservers) do
	vim.lsp.enable(server_name)
end

-- close lsp when no longer in use
df.autocmd('LspDetach', { callback = function(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client and vim.tbl_count(client.attached_buffers) <= 1 then
		client.stop(5000) -- timeout
		vim.notify('lsp ' .. client.name .. ' stopped')
	end
end})
