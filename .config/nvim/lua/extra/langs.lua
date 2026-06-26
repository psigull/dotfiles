-- language -> lsp server
-- empty server for treesitter only (no lsp)

local lsp_map = {
	rust	= 'rust_analyzer',
	go 		= 'gopls',
	c 		= 'clangd',
	cpp 	= 'clangd',
	lua 	= 'lua_ls',
	python 	= 'pyright',

	-- highlighting only
	-- verify treesitter names
	gomod	= '',
	c_sharp = '',
	typescript 	= '',
	javascript 	= '',
	tsx		= '',
}


-- parse config
df.lspservers = {}
df.tslangs = {}
for lang, server in pairs(lsp_map) do
	table.insert(df.tslangs, lang)
	if #server > 0 then
		table.insert(df.lspservers, server)
	end
end
