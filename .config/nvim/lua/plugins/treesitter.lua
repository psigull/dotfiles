return {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
	config = function()
		--require('nvim-treesitter').install(df.tslangs)
		-- TODO: implement custom loader or arborist
    end
}
