-- language -> lsp server
-- prefix language with _ to skip treesitter
-- prefix server with ! to skip mason install and initialize local lsp
-- empty server for treesitter only (no lsp)
-- is this confusing? yes.

local lsp_map = {
	rust 	 = '!rust_analyzer',
	gdscript = '!godot',
		gdshader = 'glsl_analyzer',
		glsl 	 = 'glsl_analyzer',
		godot_resource = '',
	vue		= 'vue_ls',
	go 		= 'gopls',
		gomod = '',

	c 		= 'clangd',
	cpp 	= 'clangd',
	c_sharp = 'omnisharp',
	lua 	= 'lua_ls',
	python 	= 'pyright',
	typescript 	= 'vtsls',
	javascript 	= 'vtsls',
	tsx			= 'vtsls',
	html 	= 'html',
	css  	= 'cssls',
	scss  	= 'cssls',
	json	= 'jsonls',
	jsonc	= 'jsonls',
	yaml	= 'yamlls',
	toml	= 'taplo',
	bash	= 'bashls',
	regex	= '',
	comment = '',
	markdown = '',
}


-- parse config
df.languages = {}
local servers = {}
local mason = {}
for lang, server in pairs(lsp_map) do
	if string.sub(lang, 1, 1) ~= '_' then
		table.insert(df.languages, lang)
	end
	if #server > 0 then
		if string.sub(server, 1, 1) == '!' then
			server = string.sub(server, 2)
		else
			mason[server] = true
		end
		servers[server] = true
	end
end

df.lspservers = {}
df.masoninstall = {}
for server, _ in pairs(servers) do table.insert(df.lspservers, server) end
for server, _ in pairs(mason) do table.insert(df.masoninstall, server) end
