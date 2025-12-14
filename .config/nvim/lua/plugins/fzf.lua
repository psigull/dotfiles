local function fzfcwd(fnc)
	local cwd = vim.fn.expand('%:p:h')
	if cwd == '' then return end
	fnc({cwd = cwd})
end

local function fzfgit(fnc)
	local file = vim.fn.expand('%:p')
	local cwd = vim.fn.shellescape(vim.fn.expand('%:p:h'))
	if vim.fn.getftype(file) == 'link' then
		local realfile = vim.fn.resolve(file)
		cwd = vim.fn.fnamemodify(realfile, ':h')
	end
	local gitroot = vim.fn.systemlist('git -C ' .. cwd .. ' rev-parse --show-toplevel')[1]
	if gitroot == '' then return end
	fnc({cwd = gitroot})
end

return {
	source = 'ibhagwan/fzf-lua',
	depends = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local fzf = require('fzf-lua')
		fzf.setup({
			files = { cmd = os.getenv("FZF_DEFAULT_COMMAND") }
		})

		df.map(df.mA, '<leader>b', fzf.buffers, df.ko)
		df.map(df.mA, '<C-p>', fzf.resume, df.koNow)
		df.map(df.mA, '<C-f>', fzf.oldfiles, df.ko)

		df.map('n', '<leader>/', fzf.blines, df.ko)
		df.map('n', '<leader>gr', fzf.lsp_references, df.ko)
		df.map('n', '<leader>xd', fzf.diagnostics_workspace, df.ko)

		df.map('n', '<leader>?', function() fzfcwd(fzf.live_grep) end, df.ko)
		df.map(df.mA, '<C-S-f>', function() fzfcwd(fzf.files) end, df.ko)
		df.map(df.mA, '<C-g>', function() fzfgit(fzf.git_status) end, df.ko)

		-- make esc terimate fzf
		df.autocmd('FileType', {
			pattern = 'fzf',
			callback = function(data)
				df.map('t', '<Esc>', '<C-c>', { buffer = data.buf })
			end
		})
	end
}
