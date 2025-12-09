local vim = vim

-- language -> lsp server
-- prefix language with _ to skip treesitter
-- prefix server with ! to initialize only (skip mason)
-- empty server for highlighting only

local lsp_map = {
	rust 	 = '!rust_analyzer', -- use rustup
	gdscript = '!godot', -- configured below
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

-- lsp buffer-local keybinds
local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gh', vim.lsp.buf.declaration, bufopts) -- header
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts) -- efinition
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts) -- view popup
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- manual server configs
vim.lsp.config['gopls'] = {
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
		},
	},
	init_options = { usePlaceholders = true, },
}

local pfx = vim.fn.stdpath('data')
local vueloc = pfx .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
vim.lsp.config['vtsls'] = {
	filetypes = { 'vue', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'tsx' },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = '@vue/typescript-plugin',
						location = vueloc,
						languages = { 'vue' },
						configNamespace = 'typescript',
					}
				}
			}
		}
	}
}

vim.lsp.config['godot'] = {
	cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
	filetypes = { 'gdscript' },
}

vim.lsp.config['rust-analyzer'] = {
	settings = {
		cargo = { features = 'all' },
		procMacro = { enable = true },
	}
}


-- parse config
local languages = {}
local servers = {}
local mason = {}
for lang, server in pairs(lsp_map) do
	if string.sub(lang, 1, 1) ~= '_' then
		table.insert(languages, lang)
	end
	if #server > 0 then
		if string.sub(server, 1, 1) == '!' then
			server = string.sub(server, 2)
		else
			table.insert(mason, server)
		end
		table.insert(servers, server)
	end
end

-- initialize treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = languages,
	highlight = { enable = true },
	indent = { enable = true },
})

-- install default servers w/ mason
local capabilities = require('blink.cmp').get_lsp_capabilities()
local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_ok then
	require("mason").setup({ PATH = "append" })
	mason_lspconfig.setup({ ensure_installed = mason })
end

-- assign defaults & enable all
local default_server = {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {},
}
for _, server_name in ipairs(servers) do
	vim.lsp.config[server_name] = vim.tbl_deep_extend('force',
		default_server, vim.lsp.config[server_name])
	vim.lsp.enable(server_name)
end

-- close lsp when no longer in use
vim.api.nvim_create_autocmd('LspDetach', { callback = function(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client and vim.tbl_count(client.attached_buffers) <= 1 then
		client.stop(5000) -- timeout
		vim.notify('lsp ' .. client.name .. ' stopped')
	end
end})
