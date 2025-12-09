return {
	source = 'nvim-telescope/telescope.nvim',
	depends = { 'nvim-lua/plenary.nvim' },
	setup = function()
		require('telescope').setup({ defaults = { preview = false } })
		df.map('n', '<C-`>', require('telescope.builtin').buffers, df.ko)
		df.map('n', '<leader>?', require('telescope.builtin').oldfiles, df.ko)
		df.map('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, df.ko)
		df.map('n', '<leader>r', require('telescope.builtin').resume, df.koNow) -- TODO: fix delay
		df.map('n', 'gr', require('telescope.builtin').lsp_references, df.ko)
		df.map('n', 'xd', require('telescope.builtin').diagnostics, df.ko)
	end
}
