local vim = vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true

vim.opt.autoindent = true
vim.opt.smartindent = true
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

-- disable winbar in diff views
local function checkdiff()
	if vim.wo.diff then require('lualine').hide()
	else require('lualine').hide({ unhide = true }) end
end
vim.api.nvim_create_autocmd('OptionSet', { pattern = "diff", callback = checkdiff })
vim.api.nvim_create_autocmd({'WinEnter','TabEnter','BufEnter'}, { pattern = "*", callback = checkdiff })

-- trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', { pattern = '*', callback = function()
	local lc = vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf())
	if lc > 10000 then return end -- skip large files
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
vim.g.mapleader = " "
map('n', '<leader><leader>', '<c-^>', opts)

-- swap paste before/after cursor
map('n', 'p', 'P', opts)
map('n', 'P', 'p', opts)

-- swap insert keys
map('n', 's', 'a', opts) -- *S*uffixed
map('n', 'a', 'i', opts) -- AAAt the front

-- save
map('n', '<C-s>', ':w<CR>', opts)
map('v', '<C-s>', '<C-C>:w<CR>', opts)
map('i', '<C-s>', '<Esc>:w<CR>a', opts)

-- jump to last change in file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	command = "silent! normal! g`\"zv",
})

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
map({'n','v'}, '<C-v>', 'P`[=`]`]l', opts)
map('i', '<C-v>', '<Esc>p`[=`]`]a', opts)

-- undo/redo
map('n', '<C-z>', 'u', opts)
map('v', '<C-z>', '<C-C>u', opts)
map('i', '<C-z>', '<C-o>u', opts)

map('n', '<C-S-z>', '<C-r>', opts)
map('v', '<C-S-z>', '<C-r>gv', opts)
map('i', '<C-S-z>', '<C-o><C-r>', opts)

-- create undo points every space
map('i', '<Space>', '<Space><C-g>u', opts)

-- 'tab' management
map({'n','v','i'}, '<C-t>', '<Esc>:enew<CR>', opts)
map({'n','v','i'}, '<C-S-t>', '<Esc>:vsplit<CR>', opts)
map({'n','v','i'}, '<A-S-t>', '<Esc>:close<CR>', opts)
map({'n','v','i'}, '<C-Tab>', '<Esc>:bnext<CR>', opts)
map({'n','v','i'}, '<C-S-Tab>', '<Esc>:bprev<CR>', opts)

-- black hole delete to void register, not clipboard
map('v', '<Del>', '"_x', opts)
map('v', '<BS>', '"_d', opts) -- consistency
-- whole line
map({'n','v'}, '<S-Del>', '<Esc>"_dd', opts)
map('i', '<S-Del>', '<C-o>"_dd', opts)

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

-- url click helper
vim.cmd('nmap <C-LeftMouse> <LeftMouse>gx')

-- open terminal to active buffer cwd
map({'n','v','i'}, '<F2>', function() vim.fn.system(string.format('alacritty --working-directory %s', vim.fn.expand('%:p:h'))) end, opts)

-- macro helpers
map('n', '<C-d>', '*', opts)
map('x', '<C-d>', 'y/\\V<C-R>"<CR>', opts)
map('n', '<C-S-d>', '*Ncgn', opts)
map('x', '<C-S-d>', 'y/\\V<C-R>"<CR>Ncgn', opts)

-- indent helper
map('i', '<Tab>', function()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then return '<C-o>S'
	else return '<Tab>' end
end, exprOpts)


-- colour scheme
require('theme_godot')
local bg='#111111'
vim.api.nvim_set_hl(0, 'Normal', { bg = bg })
vim.api.nvim_set_hl(0, 'NonText', { bg = bg })

-- plugins
require('pluginsetup')
