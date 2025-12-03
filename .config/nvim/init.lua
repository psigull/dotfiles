local vim = vim
vim.cmd('startinsert')

vim.opt.number = true
vim.opt.wrap = true
vim.opt.mouse = 'a'

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

-- copy/cut/paste
map('n', '<C-c>', 'yy', oCpts)
map('v', '<C-c>', 'ya', opts)
map('i', '<C-c>', '<Esc>yya', opts)

map('n', '<C-x>', 'dd', opts)
map('v', '<C-x>', 'da', opts)
map('i', '<C-x>', '<Esc>dda', opts)

map('n', '<C-v>', 'P', opts)
map('i', '<C-v>', '<Esc>pa', opts)

-- undo/redo
map('n', '<C-z>', 'u', opts)
map('v', '<C-z>', '<C-C>u', opts)
map('i', '<C-z>', '<Esc>u', opts)

map('v', '<C-r>', '<C-r>gv', opts)
map('i', '<C-r>', '<C-o><C-r>', opts)

-- down arrow creates new line if there isn't one
local expropts = vim.tbl_extend("force", opts, { expr = true })
map('n', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and 'o' or 'j' end, expropts)
map('i', '<Down>', function() return (vim.fn.line('.') == vim.fn.line('$') and vim.fn.getline('$') ~= '') and '<End><CR>' or '<C-O>j' end, expropts)


-- colour scheme
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })

