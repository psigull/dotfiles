local vim = vim
vim.cmd('startinsert')

vim.opt.number = true
vim.opt.wrap = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.whichwrap:append('<,>,[,]') -- arrow key line wrapping
vim.opt.clipboard:append('unnamedplus') -- use system clipboard

-- disable auto commenting on newline
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end })


-- key mappings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- swap paste before/after cursor
map('n', 'p', 'P', opts)
map('n', 'P', 'p', opts)

-- inSert
map('n', 's', 'i', opts)

-- save and quit
map('n', '<C-s>', ':w<CR>', opts)
map('v', '<C-s>', '<C-C>:w<CR>', opts)
map('i', '<C-s>', '<Esc>:w<CR>a', opts)

map('n', '<C-q>', ':q<CR>', opts)
map({'v','i'}, '<C-q>', '<Esc>:q<CR>', opts)

map('n', '<C-S-q>', ':qa<CR>', opts)
map({'v','i'}, '<C-S-q>', '<Esc>:qa<CR>', opts)


-- copy/cut/paste
map('n', '<C-c>', 'yy', oCpts)
map('v', '<C-c>', 'ya', opts)
map('i', '<C-c>', '<Esc>yya', opts)

map('n', '<C-x>', 'dd', opts)
map('v', '<C-x>', 'da', opts)
map('i', '<C-x>', '<Esc>dda', opts)

map({'n', 'v'}, '<C-v>', 'P=`]', opts) -- reindent
map('i', '<C-v>', '<Esc>p=`]a', opts)

-- undo/redo
map('n', '<C-z>', 'u', opts)
map('v', '<C-z>', '<C-C>u', opts)
map('i', '<C-z>', '<Esc>u', opts)

map('n', '<C-S-z>', '<C-r>', opts)
map('v', '<C-S-z>', '<C-r>gv', opts)
map('i', '<C-S-z>', '<C-o><C-r>', opts)

-- down arrow creates new line if there isn't one
local expropts = vim.tbl_extend("force", opts, { expr = true })
map('n', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and 'o' or 'j' end, expropts)
map('i', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and '<End><CR>' or '<C-O>j' end, expropts)

-- tabs
map({'n','v','i'}, '<C-t>', '<Esc>:tabnew<CR>i', opts)
map({'n','v','i'}, '<C-S-t>', '<Esc>:vnew<CR>i', opts)
map({'n','v','i'}, '<C-Tab>', '<Esc>:tabnext<CR>i', opts)
map({'n','v','i'}, '<C-S-Tab>', '<Esc>:tabprev<CR>i', opts)

-- black hole delete
map({'n', 'v'}, '<Del>', '"_x', opts)
map({'n', 'v'}, '<BS>', '"_x', opts)

-- colour scheme
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })


-- plugins
local ok, minideps = pcall(require, 'mini.deps')
if not ok then
	print("mini.deps not found")
else
	minideps.setup({})
	local add = minideps.add

	--vim.g.loaded_netrw       = 1
	--vim.g.loaded_netrwPlugin = 1

	vim.opt.showmode = false
	add({source='nvim-lualine/lualine.nvim', depends={ 'nvim-tree/nvim-web-devicons' }})
	require('lualine').setup()

	vim.g.VM_maps = {
		["Find Under"] = "<C-d>",
		["Find Subword Under"] = "<C-d>",
		["Undo"] = '<C-z>',
		["Redo"] = '<C-S-z>',
	}
	vim.g.VM_mouse_mappings = 1
	add({source='mg979/vim-visual-multi'})
end

