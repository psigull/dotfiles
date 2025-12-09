-- pipe so godot doesn't open a million nvims
-- usage:  --server {project}/.nvimpipe --remote-send "<C-\><C-N>:e {file}<CR>:call cursor({line}+1,{col})<CR>"
local cwd = vim.fn.expand('%:p:h')
local pipe = cwd .. '/.nvimpipe'
if vim.uv.fs_stat(cwd .. '/project.godot') then
	if not vim.uv.fs_stat(pipe) then
		vim.fn.serverstart(pipe)

		-- cleanup on exit
		df.autocmd('VimLeavePre', { callback = function()
			vim.uv.fs_unlink(pipe)
		end})
	end
end
