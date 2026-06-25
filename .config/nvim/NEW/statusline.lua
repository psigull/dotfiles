-- Native, ultra-fast statusline function
function df.native_status()
	local mode_map = {
		n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
		['\22'] = 'V-BLOCK', c = 'COMMAND', t = 'TERMINAL'
	}

	-- Mode and Macro recording status
	local current_mode = mode_map[vim.api.nvim_get_mode().mode] or 'NORMAL'
	local recording = vim.fn.reg_recording()
	local mode_str = recording ~= '' and string.format(' REC @%s ', recording) or string.format(' %s ', current_mode)

	-- Git branch via gitsigns buffer variable
	local git = vim.b.gitsigns_status_dict
	local branch = (git and git.head and git.head ~= '') and string.format('  %s ', git.head) or ''

	-- File details
	local file_name = vim.fn.expand('%:t')
	if file_name == '' then file_name = '[Empty]' end
	local modified = vim.bo.modified and ' [+]' or ''

	-- Assemble using standard statusline item syntax
	-- %## switches highlight groups dynamically
	return string.format(
		'%%#TabLineSel#%s%%#StatusLine#%s │ %s%s %%= %%#TabLineSel# %%l:%%c │ %%p%% ',
		mode_str, branch, file_name, modified
	)
end

-- Force Neovim to evaluate our Lua function globally for the top winbar
vim.opt.winbar = '%{%v:lua.df.native_status()%}'
vim.opt.cmdheight = 1 -- Set to 1 so native commands and messages don't cause layout jump-scares
vim.opt.showmode = false
