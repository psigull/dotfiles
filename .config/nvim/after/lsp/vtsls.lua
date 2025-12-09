local lsppath = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
local vue_plugin = {
	name = '@vue/typescript-plugin',
	location = lsppath,
	languages = { 'vue' },
	configNamespace = 'typescript',
}

return {
	filetypes = { 'vue', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				}
			}
		}
	}
}
