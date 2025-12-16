-- restore last session
vim.opt.sessionoptions = 'buffers,folds,tabpages,globals,localoptions'

local sessfile = vim.fn.expand('~/.nvimsession')
df.autocmd('VimLeavePre', { callback = function()
	-- only save if there's something worth saving
	for buf = 1, vim.fn.bufnr('$') do
		if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
			vim.cmd('silent! argd *')
			vim.cmd('mksession! ' .. sessfile)
			return
		end
	end
end})

df.autocmd('VimEnter', { callback = function()
	if vim.fn.filereadable(sessfile) == 1 then
		local bufname = vim.api.nvim_buf_get_name(0)
		local buf = vim.api.nvim_get_current_buf()

		pcall(vim.cmd('source ' .. sessfile))
		vim.fn.delete(sessfile)

		-- reopen focused buffer (cli arg)
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_set_current_buf(buf)
		end

		-- nothing was focused before
		if bufname == "" then
			vim.cmd('Dashboard')
		end
	end
end})
