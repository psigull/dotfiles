-- lsp buffer-local keybinds
local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gh', vim.lsp.buf.declaration, bufopts) -- header
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts) -- definition
	--vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- assign defaults and enable all
local capabilities = require('blink.cmp').get_lsp_capabilities()
local default_server = {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {},
}

for _, server_name in ipairs(df.lspservers) do
	vim.lsp.config[server_name] = vim.tbl_deep_extend('force',
		default_server, vim.lsp.config[server_name])
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
