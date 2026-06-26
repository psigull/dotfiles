-- plugin loader with mini.deps
-- because ofc i have to reinvent the wheel
local ok, minideps = pcall(require, 'mini.deps')
if not ok then return end

df.now = minideps.now
df.later = minideps.later

local tmpl = {
	source = '',
	depends = {},
	hooks = {},
	checkout = nil,
	config = nil,
}

local function load(name)
	local definition = require('plugins.' .. name)
	local plugin = vim.tbl_extend('force', {}, tmpl, definition)

	minideps.add({
		source 	= plugin.source,
		depends = plugin.depends,
		hooks = plugin.hooks,
		checkout = plugin.checkout,
	})

	if plugin.config ~= nil then plugin.config() end
end

-- load plugins
load'fzf'
load'yazi'
load'dashboard'
load'lspconfig'
load'treesitter'
load'outliner'
load'blink'
load'bufdel'
load'csv'
load'illuminate'
load'grugfar'
load'fugitive'
load'gitsigns'
