return {
	source = 'ojroques/nvim-bufdel',
	config = function()
		require('bufdel').setup({ next = 'tabs', quit = false })
		df.map('n', '<C-w>', ':conf BufDel<CR>', df.koNow)
		df.map({'v','i'}, '<C-w>', '<Esc>:conf BufDel<CR>', df.koNow)
	end
}
