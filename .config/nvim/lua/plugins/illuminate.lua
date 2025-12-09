return {
	source = 'RRethy/vim-illuminate',
	setup = function()
		require('illuminate').configure({
			providers = { 'lsp', 'treesitter', 'regex' }
		})
	end
}
