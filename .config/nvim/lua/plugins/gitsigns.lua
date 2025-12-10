return {
	source = 'lewis6991/gitsigns.nvim',
	config = function ()
		local gs = require('gitsigns')
		gs.setup({})
		df.map('n', '[g', gs.prev_hunk, df.ko)
		df.map('n', ']g', gs.next_hunk, df.ko)
		df.map('n', '<leader>gp', gs.preview_hunk, df.ko)
		df.map('n', '<leader>gs', gs.preview_hunk, df.ko)
		df.map('n', '<leader>gu', gs.reset_hunk, df.ko)
		df.map('n', '<leader>gb', gs.blame_line, df.ko)
	end
}
