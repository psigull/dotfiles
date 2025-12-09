return {
	source = 'windwp/nvim-autopairs',
	setup = function ()
		require('nvim-autopairs').setup({
			check_ts = true,
		})
	end
}
