local vim = vim

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.virtualedit:append('onemore') -- cursor pos on mouse click
vim.opt.whichwrap:append('<,>,[,]') -- arrow key line wrapping
vim.opt.clipboard:append('unnamedplus') -- use system clipboard

-- case insensitive search unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- disable auto commenting on newline
-- TODO: doesn't work on paste
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end })


-- key mappings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- swap paste before/after cursor
map('n', 'p', 'P', opts) 
map('n', 'P', 'p', opts) 

-- swap insert keys
map('n', 's', 'a', opts) -- suffixed
map('n', 'a', 'i', opts) -- AAAt the front

-- save
map('n', '<C-s>', ':w<CR>', opts) 
map('v', '<C-s>', '<C-C>:w<CR>', opts) 
map('i', '<C-s>', '<Esc>:w<CR>a', opts) 

-- close tab/buffer
map('n', '<C-q>', ':conf bd<CR>', opts) 
map({'v','i'}, '<C-q>', '<Esc>:conf bd<CR>', opts) 

-- close nvim
map('n', '<C-S-q>', ':conf qa<CR>', opts) 
map({'v','i'}, '<C-S-q>', '<Esc>:conf qa<CR>', opts) 

-- copy/cut/paste
map('n', '<C-c>', 'yy', opts) 
map('v', '<C-c>', 'y', opts) 
map('i', '<C-c>', '<Esc>yya', opts) 

map('n', '<C-x>', 'dd', opts) 
map('v', '<C-x>', 'd', opts) 
map('i', '<C-x>', '<Esc>dda', opts) 

map({'n','v'}, '<C-v>', 'P=`]', opts) -- reindent
map('i', '<C-v>', '<Esc>p=`]a', opts) 
-- TODO: function to trim whitespace, reindent, and place cursor at end
-- TODO: remove stray newlines at beginning and end if pasted in insert mode

-- undo/redo
map('n', '<C-z>', 'u', opts) 
map('v', '<C-z>', '<C-C>u', opts) 
map('i', '<C-z>', '<Esc>u', opts) 

map('n', '<C-S-z>', '<C-r>', opts) 
map('v', '<C-S-z>', '<C-r>gv', opts) 
map('i', '<C-S-z>', '<C-o><C-r>', opts)

-- map space to create undo point per word
map('i', '<Space>', '<Space><C-g>u', opts)

-- tab management
map({'n','v','i'}, '<C-t>', '<Esc>:tabnew<CR>', opts) 
map({'n','v','i'}, '<C-S-t>', '<Esc>:vnew<CR>', opts) -- split
-- overwritten below if plugins are available:
map({'n','v','i'}, '<C-Tab>', '<Esc>:tabnext<CR>', opts)
map({'n','v','i'}, '<C-S-Tab>', '<Esc>:tabprev<CR>', opts)

-- black hole delete to void register, not clipboard
map({'n','v'}, '<Del>', '"_x', opts)
map({'n','v','i'}, '<S-Del>', '<Esc>"_dd', opts) -- whole line
map({'n','v'}, '<C-S-x>', '"_x', opts)

-- keep selection on < > indent shifts
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- home/end ignore whitespace
map({'n','v','i'}, '<Home>', '<C-o>^', opts)
map({'n','v','i'}, '<End>', '<C-o>$', opts)

-- down arrow creates new line if there isn't one
local exprOpts = vim.tbl_extend("force", opts, { expr = true })
map('n', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and 'o' or 'j' end, exprOpts )
map('i', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and '<End><CR>' or '<C-O>j' end, exprOpts )

-- open terminal to active buffer cwd
map({'n','v','i'}, '<F2>', function() vim.fn.system(string.format('kitty --detach --directory %s', vim.fn.expand('%:p:h'))) end, opts) 


-- colour scheme
require('theme_godot')
local bg='#111111'
vim.api.nvim_set_hl(0, 'Normal', { bg = bg })
vim.api.nvim_set_hl(0, 'NonText', { bg = bg })

-- plugins
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
	add({source='nvim-lualine/lualine.nvim', depends={ 'nvim-tree/nvim-web-devicons' }})

	-- lsp breadcrumb
	add({source='SmiteshP/nvim-navic'})
	local navic = require("nvim-navic")
	navic.setup({
		lsp = { auto_attach = true },
	})

	require('lualine').setup({
		sections = {
			lualine_c = {
				"filename",
				"navic",
			}
		}
	})

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
	map({'n','v','i'}, '<C-Tab>', '<Esc>:BufferNext<CR>i', opts) 
	map({'n','v','i'}, '<C-S-Tab>', '<Esc>:BufferPrevious<CR>i', opts) 

	-- multipurpose fuzzy search popup
	add({source='nvim-telescope/telescope.nvim', depends={'nvim-lua/plenary.nvim'}})
	require('telescope').setup({defaults={preview=false}})
	map('n', '<leader><space>', require('telescope.builtin').buffers, opts) 
	map('n', '<leader>?', require('telescope.builtin').oldfiles, opts) 
	map('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, opts) 
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
	add({source='hrsh7th/nvim-cmp'})

	add({source='mason-org/mason.nvim'})
	add({source='mason-org/mason-lspconfig.nvim'})
	require('lspsetup')

	add({source='hedyhli/outline.nvim'})
	require('outline').setup({})
	map('n', "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle outliner" })

	-- start pipe if launched in godot project dir
	require('pipe_godot')
end

