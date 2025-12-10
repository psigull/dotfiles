return {
	source = 'ibhagwan/fzf-lua',
	depends = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local fzf = require('fzf-lua')

		df.map(df.mA, '<C-`>', fzf.buffers, df.ko)
		df.map(df.mA, '<C-p>', fzf.resume, df.koNow)
		df.map(df.mA, '<C-f>', fzf.oldfiles, df.ko)
		df.map(df.mA, '<C-g>', fzf.git_status, df.ko)

		df.map('n', '<leader>/', fzf.blines, df.ko)
		df.map('n', '<leader>gr', fzf.lsp_references, df.ko)
		df.map('n', '<leader>xd', fzf.diagnostics_workspace, df.ko)

		df.map('n', '<leader>?', function()
			local cwd = vim.fn.expand('%:p:h')
			if cwd == '' then return end
			fzf.live_grep({cwd = cwd})
		end, df.ko)

		df.map(df.mA, '<C-S-f>', function()
			local cwd = vim.fn.expand('%:p:h')
			if cwd == '' then return end
			fzf.files({cwd = cwd})
		end, df.ko)
	end
}
