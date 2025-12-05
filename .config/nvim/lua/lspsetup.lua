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


-- completion hotkeys
local cmp = require('cmp')
local cmp_mapping = {
	['<Up>'] = cmp.mapping(function(fb)
		if cmp.visible() then cmp.select_prev_item()
		else fb() end end, { 'i', 'c' }),
	['<Down>'] = cmp.mapping(function(fb)
		if cmp.visible() then cmp.select_next_item()
		else fb() end end, { 'i', 'c' }),
	['<C-Space>'] = cmp.mapping.complete(),
	['<Esc>'] = cmp.mapping.abort(),
	['<Tab>'] = cmp.mapping.confirm({ select = true }),
}


cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert(cmp_mapping),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp'},
		{ name = 'nvim_lsp_signature_help' },
	}, {
		{ name = 'buffer' },
	}, {
		{ name = 'path' },
	}),
	completion = { insert = false, keyword_length = 3 },
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(cmp_mapping),
	sources = {
		{ name = 'buffer', keyword_length = 1 }
	}
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(cmp_mapping),
	sources = cmp.config.sources({
		{ name = 'path', keyword_length = 1 }
	}, {
		{ name = 'cmdline', keyword_length = 1 }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

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
local capabilities = require('cmp_nvim_lsp').default_capabilities()
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

