local vim = vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"
vim.opt.fillchars = { eob = ' ' }

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.virtualedit:append('onemore') -- cursor pos on mouse click
vim.opt.whichwrap:append('<,>,[,]') -- arrow key line wrapping
vim.opt.clipboard:append('unnamedplus') -- use system clipboard

-- case insensitive search unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- disable auto commenting on newline
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end })

-- trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', { pattern = '*', callback = function()
	local view = vim.fn.winsaveview()
	vim.cmd [[keepjumps keeppatterns silent! :%s/\s\+$//e]] -- lines
	vim.cmd [[keepjumps keeppatterns silent! :%s/\($\n\s*\)\+\%$//e]] -- eof
	vim.fn.winrestview(view)
end })

-- create path on save if nonexistent
vim.api.nvim_create_autocmd('BufWritePre', { pattern = '*', callback = function(event)
	if event.match:match("^%w%w+://") then return end
	local file = vim.loop.fs_realpath(event.match) or event.match
	vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
end })

-- key mappings
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
local nowOpts = vim.tbl_extend("force", opts, { nowait = true })
map('n', '<C-w>', ':conf bd<CR>', nowOpts)
map({'v','i'}, '<C-w>', '<Esc>:conf bd<CR>', nowOpts)

-- close nvim
map('n', '<C-q>', ':conf qa<CR>', opts)
map({'v','i'}, '<C-q>', '<Esc>:conf qa<CR>', opts)

-- copy/cut/paste
map('n', '<C-c>', 'yy', opts)
map('v', '<C-c>', 'y', opts)
map('i', '<C-c>', '<Esc>yya', opts)

map('n', '<C-x>', 'dd', opts)
map('v', '<C-x>', 'd', opts)
map('i', '<C-x>', '<Esc>dda', opts)

-- reindent and place cursor at the end
map({'n','v'}, '<C-v>', 'P=`]g`]', opts)
map('i', '<C-v>', '<Esc>p=`]g`]a', opts)

-- undo/redo
map('n', '<C-z>', 'u', opts)
map('v', '<C-z>', '<C-C>u', opts)
map('i', '<C-z>', '<C-o>u', opts)

map('n', '<C-S-z>', '<C-r>', opts)
map('v', '<C-S-z>', '<C-r>gv', opts)
map('i', '<C-S-z>', '<C-o><C-r>', opts)

-- create undo points every space
map('i', '<Space>', '<Space><C-g>u', opts)

-- tab management
map({'n','v','i'}, '<C-t>', '<Esc>:tabnew<CR>', opts)
map({'n','v','i'}, '<C-S-t>', '<Esc>:vnew<CR>', opts) -- split
-- overwritten below if plugins are available:
map({'n','v','i'}, '<C-Tab>', '<Esc>:tabnext<CR>', opts)
map({'n','v','i'}, '<C-S-Tab>', '<Esc>:tabprev<CR>', opts)

-- black hole delete to void register, not clipboard
map({'n','v'}, '<Del>', '"_x', opts)
map({'n','v'}, '<C-S-x>', '"_x', opts) -- convenience
map('v', '<BS>', '"_d', opts) -- consistency
map({'n','v'}, '<S-Del>', '<Esc>"_dd', opts) -- whole line
map('i', '<S-Del>', '<C-o>"_dd', opts) -- whole line

-- keep selection on < > indent shifts
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- home/end ignore whitespace
map({'n','v'}, '<Home>', '^', opts)
map({'n','v'}, '<End>', '$', opts)
map('i', '<Home>', '<C-o>^', opts)
map('i', '<End>', '<C-o>$', opts)

-- go down a line on enter
map('n', '<CR>', 'j', opts)

-- select all
map({'n','v','i'}, '<C-a>', '<Esc>ggVG', opts)

-- down arrow creates new line if there isn't one
local exprOpts = vim.tbl_extend("force", opts, { expr = true })
map('n', '<Down>', function() return vim.fn.line('.') == vim.fn.line('$') and 'o<Esc>' or 'j' end, exprOpts )
map('i', '<Down>', function() return vim.fn.line('.') == vim.fn.line('$') and '<End><CR>' or '<C-O>j' end, exprOpts )

-- open terminal to active buffer cwd
map({'n','v','i'}, '<F2>', function() vim.fn.system(string.format('alacritty --working-directory %s', vim.fn.expand('%:p:h'))) end, opts)

-- macro helpers
map('n', '<C-d>', '*', opts)
map('x', '<C-d>', 'y/\\V<C-R>"<CR>', opts)
map('n', '<C-S-d>', '*Ncgn', opts)
map('x', '<C-S-d>', 'y/\\V<C-R>"<CR>Ncgn', opts)

-- colour scheme
require('theme_godot')
local bg='#111111'
vim.api.nvim_set_hl(0, 'Normal', { bg = bg })
vim.api.nvim_set_hl(0, 'NonText', { bg = bg })

-- plugins
require('pluginsetup')
