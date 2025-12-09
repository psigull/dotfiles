local vim = vim
local cwd = vim.fn.expand('%:p:h')
local pipe = cwd .. '/.nvimpipe'
if vim.uv.fs_stat(cwd .. '/project.godot') then
	if not vim.uv.fs_stat(pipe) then
		vim.fn.serverstart(pipe)

		-- cleanup on exit
		vim.api.nvim_create_autocmd('VimLeavePre', {
			group = vim.api.nvim_create_augroup('GodotServerCleanup', { clear = true }),
			callback = function() vim.uv.fs_unlink(pipe) end,
		})
	end
end
