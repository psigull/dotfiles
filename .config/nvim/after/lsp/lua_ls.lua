return {
	settings = {
		['lua_ls'] = {
			Lua = {
				-- fix nvim and qutebrowser configs
				diagnostics = { globals = { "vim", "config", "c" } },
			},
		}
	}
}
