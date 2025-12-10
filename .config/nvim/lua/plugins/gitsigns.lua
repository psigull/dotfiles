return {
	source = 'lewis6991/gitsigns.nvim',
	config = function ()
		local gs = require('gitsigns')
		gs.setup({})
		df.map('n', '[g', gs.prev_hunk, df.ko)
		df.map('n', ']g', gs.next_hunk, df.ko)
		df.map('n', '<leader>gp', gs.preview_hunk_inline, df.ko)
		df.map('n', '<leader>gs', gs.stage_hunk, df.ko)
		df.map('n', '<leader>gr', gs.reset_hunk, df.ko)
		df.map('n', '<leader>gb', gs.blame_line, df.ko)

		-- attach gitsigns to buffers loaded by session
		df.autocmd('VimEnter', { callback = function()
			df.later(function ()
				for buf = 1, vim.fn.bufnr('$') do
					if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
						gs.attach(buf)
					end
				end
			end)
		end})
	end
}
