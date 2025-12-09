df.map = vim.keymap.set
df.ko = { noremap = true, silent = true }
df.koNow = vim.tbl_extend("force", df.ko, { nowait = true })
df.koExpr = vim.tbl_extend("force", df.ko, { expr = true })
df.mA = {'n','x','i'}

-- global keymaps
vim.g.mapleader = " "
df.map('n', '<leader><leader>', '<c-^>', df.ko)

-- insert keys
df.map('n', 's', 'a', df.ko) -- *S*uffixed
df.map('n', 'a', 'i', df.ko) -- AAAt the front
df.map('x', 's', 'A', df.ko)
df.map('x', 'a', 'ov', df.ko) -- TODO: fix delay

-- swap paste before/after cursor
df.map('n', 'p', 'P', df.ko)
df.map('n', 'P', 'p', df.ko)

-- copy/cut/paste
df.map('n', '<C-c>', 'yy', df.ko)
df.map('v', '<C-c>', 'y', df.ko)
df.map('i', '<C-c>', '<Esc>yya', df.ko)

df.map('n', '<C-x>', 'dd', df.ko)
df.map('v', '<C-x>', 'd', df.ko)
df.map('i', '<C-x>', '<Esc>dda', df.ko)

-- reindent and place cursor at the end
df.map({'n','v'}, '<C-v>', 'p', df.ko)
df.map('i', '<C-v>', "<C-o>P", df.ko)
df.map({'n','v'}, '<C-r>', '`[=`]`]$')
df.map('i', '<C-r>', '<Esc>`[=`]`]$a')

-- delete to void register
df.map('v', '<BS>', '"_d', df.ko)
df.map({'n','v'}, '<Del>', '"_x', df.ko)
df.map({'n','v'}, '<S-Del>', '<Esc>"_dd', df.ko)
df.map('i', '<S-Del>', '<C-o>"_dd', df.ko)

-- keep selection on < > indent shifts
df.map('v', '<', '<gv', df.ko)
df.map('v', '>', '>gv', df.ko)

-- macro helpers
df.map('n', '<C-d>', '*', df.ko)
df.map('x', '<C-d>', 'y/\\V<C-R>"<CR>', df.ko)
df.map('n', '<C-S-d>', '*Ncgn', df.ko)
df.map('x', '<C-S-d>', 'y/\\V<C-R>"<CR>Ncgn', df.ko)

-- undo/redo
df.map('n', '<C-z>', 'u', df.ko)
df.map('v', '<C-z>', '<C-C>u', df.ko)
df.map('i', '<C-z>', '<C-o>u', df.ko)

df.map('n', '<C-S-z>', '<C-r>', df.ko)
df.map('v', '<C-S-z>', '<C-r>gv', df.ko)
df.map('i', '<C-S-z>', '<C-o><C-r>', df.ko)

-- save
df.map('n', '<C-s>', ':w ++p<CR>', df.ko)
df.map('v', '<C-s>', '<C-C>:w ++p<CR>', df.ko)
df.map('i', '<C-s>', '<C-o>:w ++p<CR>', df.ko)

-- buffer management
df.map({'n','v','i'}, '<C-t>', '<Esc>:enew<CR>', df.ko)
df.map({'n','v','i'}, '<C-S-t>', '<Esc>:vsplit<CR>', df.ko)
df.map({'n','v','i'}, '<C-S-w>', '<Esc>:close<CR>', df.ko)
df.map({'n','v','i'}, '<C-Tab>', '<Esc>:bnext<CR>', df.ko)
df.map({'n','v','i'}, '<C-S-Tab>', '<Esc>:bprev<CR>', df.ko)

-- close tab/buffer
df.map('n', '<C-w>', ':conf bd<CR>', df.koNow)
df.map({'v','i'}, '<C-w>', '<Esc>:conf bd<CR>', df.koNow)

-- close nvim
df.map('n', '<C-q>', ':conf qa<CR>', df.ko)
df.map({'v','i'}, '<C-q>', '<Esc>:conf qa<CR>', df.ko)

-- david blaine escape key
df.map(df.mA, '<Esc>', function()
	vim.cmd 'noh'
	return '<Esc>'
end, df.koExpr)

-- select all
df.map({'n','v','i'}, '<C-a>', '<Esc>ggVG', df.ko)

-- create undo points every space
df.map('i', '<Space>', '<Space><C-g>u', df.ko)

-- home/end ignore whitespace
df.map({'n','v'}, '<Home>', '^', df.ko)
df.map({'n','v'}, '<End>', '$', df.ko)
df.map('i', '<Home>', '<C-o>^', df.ko)
df.map('i', '<End>', '<C-o>$', df.ko)

-- go down a line on enter
df.map('n', '<CR>', 'j', df.ko)

-- url click helper
vim.cmd('nmap <C-LeftMouse> <LeftMouse>gx')

-- open terminal to active buffer cwd
df.map({'n','v','i'}, '<F2>', function()
	vim.fn.system(string.format('alacritty --working-directory %s', vim.fn.expand('%:p:h')))
end, df.ko)

-- down arrow creates new line if there isn't one
df.map('n', '<Down>', function() return vim.fn.line('.') == vim.fn.line('$') and 'o<Esc>' or 'j' end, df.koExpr)
df.map('i', '<Down>', function() return vim.fn.line('.') == vim.fn.line('$') and '<End><CR>' or '<C-O>j' end, df.koExpr)

-- indent helper
df.map('i', '<S-Tab>', function()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then return '<C-o>S'
	else return '<Tab>' end
end, df.koExpr)
