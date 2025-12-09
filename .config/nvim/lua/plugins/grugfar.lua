return {
	source = 'MagicDuck/grug-far.nvim',
	config = function()
		require('grug-far').setup({
			history = { persist = true },
		})
		df.map({'n','v'}, '<leader>gf', function()
			require('grug-far').open({ transient = true, prefills = { paths = vim.fn.expand('%:p:h') } })
		end, df.ko)
	end
}
