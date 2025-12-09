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
	setup = nil,
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

	if plugin.setup ~= nil then plugin.setup() end
end

-- load plugins
load'fzf'
load'yazi'
load'dashboard'
load'buffersticks'
load'noice'
load'notify'
load'lspconfig'
load'treesitter'
load'mason'
load'blink'
load'lualine'
load'minimap'
load'bufdel'
load'csv'
load'hexcolours'
load'illuminate'
load'outliner'
load'inlinediag'
load'pairs'
load'grugfar'
load'lazydev'
