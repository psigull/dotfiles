return {
	settings = {
		['rust-analyzer'] = {
			diagnostics = { enable = false },
			procMacro = { enable = false },
			cargo = {
				check = { enable = false },
				loadOutDirsFromCheck = false,
			},
			cachePriming = { enable = false },
			inlayHints = { chainingHints = { enable = false } },
		}
	}
}
