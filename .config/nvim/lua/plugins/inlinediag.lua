return {
	source = 'rachartier/tiny-inline-diagnostic.nvim',
	setup = function()
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = {
					enabled = true,
				},
			},
		})
	end
}
