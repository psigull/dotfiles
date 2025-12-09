return {
	source = 'Isrothy/neominimap.nvim',
	setup = function()
		df.now(function() require('neominimap.api').disable() end) -- start closed
		df.map('n', '<C-m>', ':Neominimap Toggle<CR>', df.ko)
	end
}
