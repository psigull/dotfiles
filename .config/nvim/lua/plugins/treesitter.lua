return {
	source = 'nvim-treesitter/nvim-treesitter',
	hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	config = function()
		vim.opt.foldmethod = 'expr'
		vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

		require('nvim-treesitter.configs').setup({
			ensure_installed = df.tslangs,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
