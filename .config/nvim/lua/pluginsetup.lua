local vim = vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local ok, minideps = pcall(require, 'mini.deps')
if ok then
	minideps.setup({})
	local add = minideps.add

	-- file explorer
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	add({source='mikavilpas/yazi.nvim', depends={'nvim-lua/plenary.nvim'}})
	require('yazi').setup({open_for_directories=false})
	map({'n','v','i'}, '<C-e>', function() require('yazi').yazi() end, opts)

	-- statusbar
	vim.opt.showmode = false
	vim.opt.cmdheight = 0
	vim.opt.ruler = false
	add({source='nvim-lualine/lualine.nvim', depends={ 'nvim-tree/nvim-web-devicons' }})
	add({source='SmiteshP/nvim-navic'})
	local navic = require("nvim-navic")
	navic.setup({
		lsp = { auto_attach = true },
	})
	require('patcher') -- fix laststatus being reset
	require('lualine').setup({
		sections = {},
		winbar = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename", "navic" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" }
		},
	})

	-- hide statusbar when lualine is on top
	vim.opt.laststatus=0
	local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
	vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color, fg = bg_color })
	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg_color, fg = bg_color })

	-- noice gui
	add({source='folke/noice.nvim', depends={'MunifTanjim/nui.nvim'}})
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
	})
	add({source='rcarriga/nvim-notify'})
	require("notify").setup({
		background_colour = "#111111",
		top_down = false,
	})

	-- quote, bracket, parenthesis pairs
	add({source='windwp/nvim-autopairs'})
	require('nvim-autopairs').setup({})

	-- pop up that shows keymappings
	add({source='folke/which-key.nvim'})
	require('which-key').setup({
		win = { height = { min = 2, max = 5 },
			padding = { 0, 0 } },
		layout = { width = { min = 25, max = 25 },
			spacing = 0 }
	})

	-- snazzy reorderable tabs
	add({source='romgrk/barbar.nvim'})
	require('barbar').setup({auto_hide=true})
	map({'n','v','i'}, '<C-Tab>', '<Esc>:BufferNext<CR>', opts)
	map({'n','v','i'}, '<C-S-Tab>', '<Esc>:BufferPrevious<CR>', opts)

	-- multipurpose fuzzy search popup
	add({source='nvim-telescope/telescope.nvim', depends={'nvim-lua/plenary.nvim'}})
	require('telescope').setup({defaults={preview=false}})
	map('n', '<leader><space>', require('telescope.builtin').buffers, opts)
	map('n', '<leader>?', require('telescope.builtin').oldfiles, opts)
	map('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, opts)
	map('n', '<leader>r', require('telescope.builtin').resume, opts)
	map('n', 'gr', require('telescope.builtin').lsp_references, opts)
	map('n', 'xd', require('telescope.builtin').diagnostics, opts)
	-- TODO: telescope git_files, help_tags
	-- TODO: difference between find_files, grep_string, live_grep?
	-- TODO: function to find in files, but specify a directory/filter first!

	-- fuzzy search open tabs
	add({source='LukasPietzschmann/telescope-tabs'})
	map({'n','v','i'}, "<C-`>", function() require('telescope-tabs').list_tabs() end, opts)

	-- language stuff
	vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
	vim.opt.signcolumn = "no"

	add({source='nvim-treesitter/nvim-treesitter'})
	add({source='neovim/nvim-lspconfig'})
	add({source='hrsh7th/cmp-nvim-lsp'})
	add({source='hrsh7th/cmp-buffer'})
	add({source='hrsh7th/cmp-path'})
	add({source='hrsh7th/cmp-cmdline'})
	add({source='hrsh7th/cmp-nvim-lsp-signature-help'})
	add({source='hrsh7th/nvim-cmp'})

	add({source='mason-org/mason.nvim'})
	add({source='mason-org/mason-lspconfig.nvim'})
	require('lspsetup') -- setup lsp configs

	-- outliner
	add({source='hedyhli/outline.nvim'})
	require('outline').setup({})
	map('n', "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle outliner" })

	-- start pipe if launched in godot project dir
	require('pipe_godot')
end



