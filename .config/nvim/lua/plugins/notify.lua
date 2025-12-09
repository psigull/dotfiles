return {
	source = 'rcarriga/nvim-notify',
	setup = function ()
		require("notify").setup({
			background_colour = "#111111",
			top_down = false,
			timeout = 2000,
			render = 'minimal', -- compact
			stages = 'slide',
		})

		df.map('n', '<C-S-n>', ':Notifications<CR>', df.ko)
	end
}
