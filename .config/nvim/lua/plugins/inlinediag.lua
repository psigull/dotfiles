return {
	source = 'rachartier/tiny-inline-diagnostic.nvim',
	config = function()
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = {
					enabled = true,
				},
			},
		})
	end
}
