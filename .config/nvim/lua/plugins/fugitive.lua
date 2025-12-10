return {
	source = 'tpope/vim-fugitive',
	config = function ()
		df.map(df.mA, '<C-S-g>', '<cmd>:Git<CR>', df.ko)

		df.autocmd('FileType', {
			pattern = 'fugitive',
			callback = function ()
				local bufnr = vim.api.nvim_get_current_buf()
				df.map('n', 'q', '<cmd>close<CR>', { buffer = bufnr })
			end
		})

		df.autocmd('FileType', {
			pattern = 'gitcommit',
			callback = function ()
				local bufnr = vim.api.nvim_get_current_buf()
				df.map('n', 'q', '<cmd>close<CR>', { buffer = bufnr })
			end
		})
	end
}
