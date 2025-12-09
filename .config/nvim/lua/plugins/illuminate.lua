return {
	source = 'RRethy/vim-illuminate',
	config = function()
		require('illuminate').configure({
			providers = { 'lsp', 'treesitter', 'regex' }
		})
	end
}
