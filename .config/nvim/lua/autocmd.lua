-- global autocmds
local group = vim.api.nvim_create_augroup("dotfiles", { clear = true })
local def_params = { group = group }
df.autocmd = function(event, _params)
	local params = vim.tbl_extend('force', {}, def_params, _params)
	vim.api.nvim_create_autocmd(event, params)
end

-- jump to last change in file
df.autocmd("BufReadPost", {
	pattern = "*",
	command = "silent! normal! g`\"zv",
})

-- disable auto commenting on newline
-- TODO: used to be BufEnter, does this work right?
df.autocmd("FileType", { pattern = "*", callback = function()
	vim.opt.formatoptions:remove({ "c", "r", "o" })
end})

-- close help windows easily
df.autocmd('FileType', {
	pattern = 'help',
	callback = function ()
		local bufnr = vim.api.nvim_get_current_buf()
		df.map('n', 'q', '<cmd>close<CR>', { buffer = bufnr })
	end
})

-- trim trailing whitespace on save
df.autocmd('BufWritePre', { pattern = '*', callback = function()
	local lc = vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf())
	if lc > 10000 then return end -- skip large files
	local view = vim.fn.winsaveview()
	vim.cmd [[keepjumps keeppatterns silent! :%s/\s\+$//e]] -- lines
	vim.cmd [[keepjumps keeppatterns silent! :%s/\($\n\s*\)\+\%$//e]] -- eof
	vim.fn.winrestview(view)
end})
