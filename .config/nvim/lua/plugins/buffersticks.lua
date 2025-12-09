return {
	source = 'ahkohd/buffer-sticks.nvim',
	setup = function()
		local sticks = require('buffer-sticks')
		sticks.setup({
			list = { show = { "filename", "space" } },
			preview = { enabled = false },
			highlights = {
				active = 			{ fg = "#a7c1aa", italic = true },
				active_modified = 	{ fg = "#a7c1aa", italic = true, bold = true },
				alternate = 			{ fg = "#666666" },
				alternate_modified = 	{ fg = "#666666", bold = true },
				inactive = 			{ fg = "#333333" },
				inactive_modified = { fg = "#333333", bold = true },
			}
		})

		-- show in list mode by default (full names)
		sticks.show()
		require('buffer-sticks.state').list_mode = true

		-- hide sticks in dashboards
		df.autocmd("FileType", { pattern = "dashboard", callback = function()
			require('buffer-sticks').hide()
		end})
		df.autocmd("BufLeave", { callback = function()
			if vim.bo.filetype == "dashboard" then require('buffer-sticks').show() end
		end})

		df.map({'n','v','i'}, '<C-h>', function() require('buffer-sticks').toggle() end, df.ko)
	end
}
