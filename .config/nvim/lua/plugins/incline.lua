return {
	source = 'b0o/incline.nvim',
	config = function()
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			hide = { only_win = true },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
				local modified = vim.bo[props.buf].modified
				return {
					' ',
					{ filename, gui = modified and 'bold,italic' or 'bold' },
					' ',
					guibg = '#44484D',
				}
			end,
		})
	end
}
