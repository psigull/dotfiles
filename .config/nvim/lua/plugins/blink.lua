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
			},
			completion = { documentation = { auto_show = false } },
		})
	end
}
