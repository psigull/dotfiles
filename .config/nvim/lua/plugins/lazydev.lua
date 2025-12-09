return {
	source = 'folke/lazydev.nvim',
	config = function()
		require('lazydev').setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end
}
