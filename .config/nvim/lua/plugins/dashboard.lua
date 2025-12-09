return {
	source = 'nvimdev/dashboard-nvim',
	setup = function()
		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#6c00ee" })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#1b3857" })

		require('dashboard').setup({
			theme = 'hyper',
			letter_list = 'bcdefghilmnopqrstuvwxyz',
			config = {
				shortcut = {},
				packages = { enable = false },
				project ={ limit = 2 },
				mru = { limit = 8 },
				footer = {'', '👽 stay weird'},
				header = {	"      |\\      _,,,---,,_     ",
							"ZZZzz /,`.-'`'    -.  ;-;;,_ ",
							"     |,4-  ) )-,_. ,\\ (  `'-'",
							"    '---''(_/--'  `-'\\_)     ", }
			}
		})

		-- dashboard local hotkey for new buffer
		df.autocmd("FileType", { pattern = "dashboard", callback = function()
			df.map('n', 'a', ':enew<CR>', { buffer = true })
		end})

		-- open on new tab
		df.autocmd('TabNewEntered', {
			callback = function() if vim.bo.filetype == "" then vim.cmd("Dashboard") end end
		})

		-- open dashboard when last buffer is closed
		df.autocmd('BufDelete', { callback = function(event)
			for buf = 1, vim.fn.bufnr('$') do
				if buf ~= event.buf and vim.fn.buflisted(buf) == 1 then
					if vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
						return
					end
				end
			end
			vim.cmd('Dashboard')
		end})

		-- open on directory
		df.autocmd('VimEnter', {
			callback = function ()
				local arg = vim.fn.argv(0)
				if arg ~= '' and vim.fn.isdirectory(arg) == 1 then
					vim.cmd('Dashboard')
				end
			end
		})

		-- new 'tab' hotkey
		df.map({'n','v','i'}, '<C-t>', '<Esc>:enew<CR><Esc>:Dashboard<CR>', df.ko)
	end
}
