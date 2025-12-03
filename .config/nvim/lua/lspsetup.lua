-- config
local lsp_map = {
	c 		= 'clangd',
	cpp 	= 'clangd',
	c_sharp = 'omnisharp',
	go 		= 'gopls',
	lua 	= 'lua_ls',
	python 	= 'pyright',
	rust 	= 'rust_analyzer',
	typescript = 'typescript-language-server',
	javascript = 'typescript-language-server',
	html 	= 'html',
	css  	= 'cssls',
}

local languages = {}
local servers = {}
for lang, server in pairs(lsp_map) do
	table.insert(languages, lang)
	table.insert(servers, server)
end

-- completion
local cmp = require('cmp')
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<Up>'] = cmp.mapping.select_next_item(),
		['<Down>'] = cmp.mapping.select_prev_item(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<Esc>'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	}, {
		{ name = 'path' },
	})
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})


-- treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = languages,
	highlight = { enable = true },
	indent = { enable = true },
})


-- lsp
local on_attach = function(client, bufnr)
	-- enable formatting on save on some servers		
	if client.name == 'tsserver' or client.name == 'pyright' then
		client.server_capabilities.documentFormattingProvider = true
	end

	-- prevent multiple servers
	if client.server_info.name == 'clangd' then
		client.handlers['textDocument/hover'] = vim.lsp.handlers.hover
	end

	-- Keymaps for LSP functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_ok then
	require("mason").setup({ PATH = "append" })
	mason_lspconfig.setup({
		ensure_installed = servers,
		handlers = {
			function(server_name)
				vim.lsp.config[server_name] = {
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {},
				}
			end,
			-- ['gopls'] = function()
				--	vim.lsp.config['gopls'] = {}
				-- end,
		}
	})
end

-- vim.lsp.config['gopls'] = {
-- 	cmd = {'gopls'},
-- 	capabilities = capabilities,
-- 	settings = {
-- 		gopls = {
-- 			experimentalPostfixCompletions = true,
-- 			analyses = {
-- 				unusedparams = true,
-- 				shadow = true,
-- 			},
-- 			staticcheck = true,
-- 		},
-- 	},
-- 	init_options = {
-- 		usePlaceholders = true,
-- 	}
-- }
