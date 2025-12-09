return {
	source = 'hedyhli/outline.nvim',
	config = function()
		require('outline').setup({ outline_window = { focus_on_open = false } })
		df.map('n', "<C-b>", function()
			vim.cmd("Outline")
			-- hide buffersticks when outliner is open
			require('buffer-sticks').toggle()
		end, df.ko)
	end
}
