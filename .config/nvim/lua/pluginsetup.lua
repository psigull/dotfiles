local vim = vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local nowOpts = vim.tbl_extend("force", opts, { nowait = true })

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
			letter_list = 'bcdefghilmnopqrstuvwxyz',
			config = {
				mru = { limit = 8 },
				project ={ limit = 2 },
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
	vim.api.nvim_create_autocmd("FileType", { pattern = "dashboard", callback = function()
		vim.keymap.set('n', 'a', ':enew<CR>', { buffer = true }) -- 'a' on dashboard for new file
	end})
	vim.api.nvim_create_autocmd('TabNewEntered', { -- open on new tab
		callback = function() if vim.bo.filetype == "" then vim.cmd("Dashboard") end end
	})
	vim.api.nvim_create_autocmd('BufDelete', { callback = function(event)
		for buf = 1, vim.fn.bufnr('$') do
			if buf ~= event.buf and vim.fn.buflisted(buf) == 1 then
				if vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
					return
				end
			end
		end
		-- open dashboard if last buffer is closed
		vim.cmd('Dashboard')
	end})

	vim.api.nvim_create_autocmd('VimEnter', {
		callback = function ()
			local arg = vim.fn.argv(0)
			if arg ~= '' and vim.fn.isdirectory(arg) == 1 then
				vim.cmd('Dashboard')
			end
		end
	})

	map({'n','v','i'}, '<C-t>', '<Esc>:enew<CR><Esc>:Dashboard<CR>', opts)

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

	-- disable winbar in diff views
	local function checkdiff()
		if vim.wo.diff then require('lualine').hide()
		else require('lualine').hide({ unhide = true }) end
	end
	vim.api.nvim_create_autocmd('OptionSet', { pattern = "diff", callback = checkdiff })
	vim.api.nvim_create_autocmd({'WinEnter','TabEnter','BufEnter'}, { pattern = "*", callback = checkdiff })


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
			},
		},
	})
	add({source='rcarriga/nvim-notify'})
	require("notify").setup({
		background_colour = "#111111",
		top_down = false,
		timeout = 2000,
		render = 'minimal', -- compact
		stages = 'slide',
	})

	-- quote, bracket, parenthesis pairs
	add({source='windwp/nvim-autopairs'})
	require('nvim-autopairs').setup({})

	-- buffer sticks
	add({source='ahkohd/buffer-sticks.nvim'})
	local sticks = require('buffer-sticks')
	sticks.setup({
		list = { show = { "filename", "space" } },
		preview = { enabled = false },
		highlights = {
			active = 			{ fg = "#a7c1aa", italic = true },
			active_modified = 	{ fg = "#a7c1aa", italic = true, bold = true },
			alternate = 			{ fg = "#666666" },
			alternate_modified = 	{ fg = "#666666", bold = true },
			inactive = 			{ fg = "#333333" },
			inactive_modified = { fg = "#333333", bold = true },
		}
	})
	sticks.show() -- show in list mode by default (full names)
	require('buffer-sticks.state').list_mode = true

	-- hide sticks in dashboards
	vim.api.nvim_create_autocmd("FileType", { pattern = "dashboard", callback = function()
		require('buffer-sticks').hide()
	end})
	vim.api.nvim_create_autocmd("BufLeave", { callback = function()
		if vim.bo.filetype == "dashboard" then require('buffer-sticks').show() end
	end})
	map({'n','v','i'}, '<C-h>', function() require('buffer-sticks').toggle() end, opts)

	-- delete buffers without losing window layout
	add({source='ojroques/nvim-bufdel'})
	require('bufdel').setup({ next = 'alternate', quit = false })
	map('n', '<C-w>', ':conf BufDel<CR>', nowOpts)
	map({'v','i'}, '<C-w>', '<Esc>:conf BufDel<CR>', nowOpts)

	-- multipurpose fuzzy search popup
	add({source='nvim-telescope/telescope.nvim', depends={'nvim-lua/plenary.nvim'}})
	require('telescope').setup({defaults={preview=false}})
	map('n', '<leader>?', require('telescope.builtin').oldfiles, opts)
	map('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, opts)
	map('n', '<leader>r', require('telescope.builtin').resume, nowOpts)
	map('n', 'gr', require('telescope.builtin').lsp_references, opts)
	map('n', 'xd', require('telescope.builtin').diagnostics, opts)

	require("telescope").load_extension("notify")
	map('n', '<C-n>', ':Telescope notify<CR>', opts)

	-- buffer list
	add({source='EL-MASTOR/bufferlist.nvim', depends={"nvim-tree/nvim-web-devicons"}})
	require('bufferlist').setup()
	map({'n','v','i'}, '<C-`>', '<Esc>:BufferList<CR>', opts)

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

	-- better inline diagnostics
	add({source='rachartier/tiny-inline-diagnostic.nvim'})
	vim.diagnostic.config({ virtual_text = false })
	require("tiny-inline-diagnostic").setup({
		options = {
			multilines = {
				enabled = true,
			},
		},
	})

	-- lsp
	add({source='mason-org/mason.nvim'})
	add({source='mason-org/mason-lspconfig.nvim'})
	require('lspsetup') -- setup lsp configs

	-- better support for vim lua
	add({source='folke/lazydev.nvim'})
	require('lazydev').setup({})

	-- outliner
	add({source='hedyhli/outline.nvim'})
	require('outline').setup({outline_window={ focus_on_open = false }})
	map('n', "<C-b>", function()
		vim.cmd("Outline")
		require('buffer-sticks').toggle()
	end)

	-- light up selected word
	add({source='RRethy/vim-illuminate'})
	require('illuminate').configure({
		providers = { 'lsp', 'treesitter', 'regex' }
	})

	-- highlight colours
	add({source='catgoose/nvim-colorizer.lua'})
	require("colorizer").setup()

	-- start pipe if launched in godot project dir
	require('pipe_godot')


	-- restore last session
	vim.opt.sessionoptions = 'buffers,curdir,folds,tabpages,globals,localoptions'
	local sessfile = vim.fn.expand('~/.nvimsession')
	vim.api.nvim_create_autocmd('VimLeavePre', { callback = function()
		-- only save if there's something worth saving
		for buf = 1, vim.fn.bufnr('$') do
			if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
				vim.cmd('mksession! ' .. sessfile)
				return
			end
		end
	end})
	vim.api.nvim_create_autocmd('VimEnter', { callback = function()
		if vim.fn.filereadable(sessfile) == 1 then
			local bufname = vim.api.nvim_buf_get_name(0)
			local buf = vim.api.nvim_get_current_buf()
				pcall(vim.cmd('source ' .. sessfile))
				vim.fn.delete(sessfile)
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_set_current_buf(buf)
			end
			if bufname == "" then
				vim.cmd('Dashboard')
			end
		end
	end})
end
