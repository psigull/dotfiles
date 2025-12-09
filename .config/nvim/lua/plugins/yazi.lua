return {
	source = 'mikavilpas/yazi.nvim',
	depends = { 'nvim-lua/plenary.nvim' },
	setup = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require('yazi').setup({
			open_for_directories = true,

			integrations = {
				grep_in_directory = function(dir)
					local fzf = require('fzf-lua')
					fzf.live_grep({ cwd = dir })
				end,
			}
		})

		df.map({'n','v','i'}, '<C-e>', function() require('yazi').yazi() end, df.ko)
	end
}
