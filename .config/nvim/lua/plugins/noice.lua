return {
	source = 'folke/noice.nvim',
	depends = { 'MunifTanjim/nui.nvim' },
	config = function ()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
				signature = { auto_open = false },
			},
		})
	end
}
