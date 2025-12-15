return {
	source = 'ahkohd/buffer-sticks.nvim',
	config = function()
		local sticks = require('buffer-sticks')
		sticks.setup({
			highlights = {
				active = { fg = "#FFFFB8" },
                alternate = { fg = "#AA759F" },
                inactive = { link = "Comment" },
                active_modified = { fg = "#9AFFFF" },
                alternate_modified = { fg = "#6A9FB5" },
                inactive_modified = { fg = "#6A9FB5" },
                label = { fg = "#D8D8D8" },
                filter_selected = { fg = "#90A959" },
                filter_title = { fg = "#D8D8D8" },
                list_selected = { fg = '#90A959' },
			}
		})

		sticks.show() -- show by default
		df.map({'n','v','i'}, '<C-`>', function() require('buffer-sticks').jump() end, df.ko)
	end
}
