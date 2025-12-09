return {
	source = 'mason-org/mason.nvim',
	depends = { 'mason-org/mason-lspconfig.nvim' },
	setup = function()
		local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
		if mason_ok then
			require("mason").setup({ PATH = "append" })
			mason_lspconfig.setup({ ensure_installed = df.masoninstall })
		end
	end
}
