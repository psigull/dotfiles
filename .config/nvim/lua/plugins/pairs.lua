return {
	source = 'windwp/nvim-autopairs',
	config = function ()
		require('nvim-autopairs').setup({
			check_ts = true,
		})
	end
}
