local vim = vim

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



