return {
	source = 'ojroques/nvim-bufdel',
	setup = function()
		require('bufdel').setup({ next = 'alternate', quit = false })
		df.map('n', '<C-w>', ':conf BufDel<CR>', df.koNow)
		df.map({'v','i'}, '<C-w>', '<Esc>:conf BufDel<CR>', df.koNow)
	end
}
