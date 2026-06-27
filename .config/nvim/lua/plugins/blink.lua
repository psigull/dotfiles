return {
	source = "saghen/blink.cmp",
	depends = { "rafamadriz/friendly-snippets" },
	checkout = 'v1.8.0',
	config = function()
		require('blink.cmp').setup({
			keymap = {
				preset = 'super-tab',
				['<Tab>'] = { 'select_and_accept', 'fallback' },
				['<S-Tab>'] = false,
				["<C-space>"] = { "show", "show_documentation", "hide" },
			},
			completion = {
				documentation = { auto_show = false },
				ghost_text = { enabled = false },
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					}
				},
			},
			cmdline = {
				enabled = true,
				keymap = { preset = 'cmdline' },
				sources = function()
					local type = vim.fn.getcmdtype()
					if type == '/' or type == '?' then return { 'buffer' } end
					if type == ':' then return { 'cmdline' } end
					return {}
				end,
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
		})
	end
}
