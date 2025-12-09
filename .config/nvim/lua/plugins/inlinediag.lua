return {
	source = 'rachartier/tiny-inline-diagnostic.nvim',
	config = function()
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
