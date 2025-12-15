local function patcher()
	local path = '~/.local/share/nvim/site/pack/deps/opt/lualine.nvim/lua/lualine.lua'
	local line = 'set_statusline = function() end'

	local check = string.format("grep '%s' %s", line, path)
	local grep = vim.fn.system(check)

	if grep == '' then
		local replace = string.format("s/^return M$/%s\\n&/", line)
		local sed = string.format("sed -i.bak '%s' %s", replace, path)
		local res = vim.fn.system(sed)
		if res ~= '' then print('error applying lualine patch: ' .. res) end
	end
end

local function recording()
	local macro = vim.fn.reg_recording()
	if macro ~= '' then return '@' .. macro end
	return ''
end

local function checkdiff()
	if vim.wo.diff then require('lualine').hide()
	else require('lualine').hide({ unhide = true }) end
end


return {
	source = 'nvim-lualine/lualine.nvim',
	depends = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
		vim.opt.showmode = false
		vim.opt.cmdheight = 0
		vim.opt.ruler = false

		-- fix laststatus being reset
		-- our bar is on the top so we dont need it! :)
		patcher()

		require('lualine').setup({
			sections = {},
			winbar = {
				lualine_a = { "mode", recording },
				lualine_b = { "branch", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" }
			},
		})

		-- hide winbar in diff views
		df.autocmd('OptionSet', { pattern = "diff", callback = checkdiff })
		df.autocmd({'WinEnter','TabEnter','BufEnter'}, { pattern = "*", callback = checkdiff })

		-- hide statusbar when lualine is on top
		vim.opt.laststatus=0
		local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).bg
		vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color, fg = bg_color })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg_color, fg = bg_color })
	end
}
