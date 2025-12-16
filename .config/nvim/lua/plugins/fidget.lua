return {
	source = 'j-hui/fidget.nvim',
	config = function ()
		require("fidget").setup({
			progress = { display = { done_ttl = 0, render_limit = 1 } },
		})
	end
}
