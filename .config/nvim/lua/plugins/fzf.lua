local function fzfcwd(fnc)
	local cwd = vim.fn.expand('%:p:h')
	if cwd == '' then return end
	fnc({cwd = cwd})
end

local function fzfgit(fnc)
	local cwd = vim.fn.shellescape(vim.fn.expand('%:p:h'))
	local gitroot = vim.fn.systemlist('git -C ' .. cwd .. ' rev-parse --show-toplevel')[1]
	if gitroot == '' then return end
	fnc({cwd = gitroot})
end

return {
	source = 'ibhagwan/fzf-lua',
	depends = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local fzf = require('fzf-lua')

		df.map(df.mA, '<C-`>', fzf.buffers, df.ko)
		df.map(df.mA, '<C-p>', fzf.resume, df.koNow)
		df.map(df.mA, '<C-f>', fzf.oldfiles, df.ko)

		df.map('n', '<leader>/', fzf.blines, df.ko)
		df.map('n', '<leader>gr', fzf.lsp_references, df.ko)
		df.map('n', '<leader>xd', fzf.diagnostics_workspace, df.ko)

		df.map('n', '<leader>?', function() fzfcwd(fzf.live_grep) end, df.ko)
		df.map(df.mA, '<C-S-f>', function() fzfcwd(fzf.files) end, df.ko)
		df.map(df.mA, '<C-g>', function() fzfgit(fzf.git_status) end, df.ko)
	end
}
