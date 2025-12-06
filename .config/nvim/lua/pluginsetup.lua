local vim = vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local ok, minideps = pcall(require, 'mini.deps')
if ok then
	minideps.setup({})
	local add = minideps.add
	local now = minideps.now

	-- dashboard
	add({source='nvimdev/dashboard-nvim'})
	vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#6c00ee" })
	vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#1b3857" })
	now(function()
		require('dashboard').setup({
			theme = 'hyper',
			config = {
				footer = {'', '👽 stay weird'},
				shortcut = {},
				packages = { enable = false },
				header = {	"      |\\      _,,,---,,_     ",
							"ZZZzz /,`.-'`'    -.  ;-;;,_ ",
							"     |,4-  ) )-,_. ,\\ (  `'-'",
							"    '---''(_/--'  `-'\\_)     ", }
			}
		})
	end)
	vim.api.nvim_create_autocmd('TabNewEntered', {
		callback = function() if vim.bo.filetype == "" then vim.cmd("Dashboard") end end
	})

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

	local function recording()
		local macro = vim.fn.reg_recording()
		if macro ~= '' then
			return '@' .. macro
		end
		return ''
	end
	require('lualine').setup({
		sections = {},
		winbar = {
			lualine_a = { "mode", recording },
			lualine_b = { "branch", "diagnostics" },
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

	-- minimap
	add({source='Isrothy/neominimap.nvim'})
	now(function() require('neominimap.api').disable() end)
	map('n', '<C-m>', ':Neominimap Toggle<CR>', opts)

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

	-- snazzy reorderable tabs
	add({source='romgrk/barbar.nvim'})
	require('barbar').setup({auto_hide=true})

	-- multipurpose fuzzy search popup
	add({source='nvim-telescope/telescope.nvim', depends={'nvim-lua/plenary.nvim'}})
	require('telescope').setup({defaults={preview=false}})
	map('n', '<leader><space>', require('telescope.builtin').buffers, opts)
	map('n', '<leader>?', require('telescope.builtin').oldfiles, opts)
	map('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, opts)
	map('n', '<leader>r', require('telescope.builtin').resume, opts)
	map('n', 'gr', require('telescope.builtin').lsp_references, opts)
	map('n', 'xd', require('telescope.builtin').diagnostics, opts)

	-- fuzzy search open tabs
	add({source='LukasPietzschmann/telescope-tabs'})
	map({'n','v','i'}, "<C-`>", function() require('telescope-tabs').list_tabs() end, opts)

	-- csv viewer
	add({source='hat0uma/csvview.nvim'})
	require('csvview').setup()

	-- language stuff
	vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
	vim.opt.signcolumn = "no"

	add({source='nvim-treesitter/nvim-treesitter'})
	add({source='neovim/nvim-lspconfig'})

	add({source = "saghen/blink.cmp",
		depends = { "rafamadriz/friendly-snippets" },
		checkout = 'v1.8.0'})
	require('blink.cmp').setup({
		keymap = { preset = 'super-tab' },
		completion = { documentation = { auto_show = true } },
	})

	add({source='mason-org/mason.nvim'})
	add({source='mason-org/mason-lspconfig.nvim'})
	require('lspsetup') -- setup lsp configs

	-- outliner
	add({source='hedyhli/outline.nvim'})
	require('outline').setup({outline_window={ focus_on_open = false }})
	map('n', "<C-b>", "<cmd>Outline<CR>", { desc = "Toggle outliner" })

	-- highlight colours
	add({source='catgoose/nvim-colorizer.lua'})
	require("colorizer").setup()

	-- start pipe if launched in godot project dir
	require('pipe_godot')
end
