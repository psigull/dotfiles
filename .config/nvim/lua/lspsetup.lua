local vim = vim

-- treesitter language -> lsp server
-- prefix language with _ to ignore syntax
-- empty server string to ignore lsp server
local lsp_map = {
	c 		= 'clangd',
	cpp 	= 'clangd',
	c_sharp = 'omnisharp',
	go 		= 'gopls', -- config below
	gomod = '',
	lua 	= 'lua_ls',
	python 	= 'pyright',
	rust 	= 'rust_analyzer',
	typescript = 'vtsls',
	javascript = 'vtsls',
	tsx		= 'vtsls',
	vue		= 'vue_ls', -- config below
	html 	= 'html',
	css  	= 'cssls',
	scss  	= 'cssls',
	json	= 'jsonls',
	jsonc	= 'jsonls',
	yaml	= 'yamlls',
	toml	= 'taplo',
	bash	= 'bashls',
	glsl 	= 'glsl_analyzer',
	gdscript = '', -- configured below
	godot_resource = '',
	gdshader = 'glsl_analyzer',
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
	filetypes = { 'vue', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
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
		inlayHints = {
			enable = true,
			showParameterNames = true,
			parameterHintsPrefix = "<- ",
			otherHintsPrefix = "=> ",
		},
	}
}


-- parse config
local languages = {}
local servers = {}
for lang, server in pairs(lsp_map) do
	if string.sub(lang, 1, 1) ~= '_' then
		table.insert(languages, lang)
	end
	if #server > 0 then
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
	mason_lspconfig.setup({ ensure_installed = servers })
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
