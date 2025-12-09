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

		-- telescope key for history
		require("telescope").load_extension("notify")
		df.map('n', '<C-S-n>', ':Telescope notify<CR>', df.ko)
	end
}
