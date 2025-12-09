local function findall()

	require('fzf-lua')
end

return {
	source = 'ibhagwan/fzf-lua',
	depends = { 'nvim-tree/nvim-web-devicons' },
	setup = function()
		local fzf = require('fzf-lua')

		df.map('n', '<C-`>', fzf.buffers, df.ko)
		df.map('n', '<C-p>', fzf.resume, df.koNow)

		df.map('n', '<C-f>', fzf.oldfiles, df.ko)
		df.map('n', '<leader>/', fzf.blines, df.ko)

		df.map('n', 'gr', fzf.lsp_references, df.ko)
		df.map('n', 'xd', fzf.diagnostics_workspace, df.ko)

		df.map('n', '<leader>?', function()
			local cwd = vim.fn.expand('%:p:h')
			if cwd == '' then return end
			fzf.live_grep({cwd = cwd})
		end, df.ko)
	end
}
