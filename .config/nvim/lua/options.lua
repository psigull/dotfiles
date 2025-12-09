-- global options
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
vim.opt.shortmess:append('A') -- hide swap file warnings

-- case insensitive search unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = 'number'

vim.diagnostic.config({
	virtual_text = false,
	underline = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		}
	}
})
