return {
	source = 'folke/lazydev.nvim',
	setup = function()
		require('lazydev').setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end
}
