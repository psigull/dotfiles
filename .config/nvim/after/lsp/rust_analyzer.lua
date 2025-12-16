return {
	settings = {
		['rust-analyzer'] = {
			cargo = { features = 'all' },
			procMacro = { enable = true },
			inlayHints = { chainingHints = { enable = false } },
		}
	}
}
