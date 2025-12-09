return {
	source = 'nvim-treesitter/nvim-treesitter',
	hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	setup = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = df.tslangs,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
