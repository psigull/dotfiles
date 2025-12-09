return {
	source = 'Isrothy/neominimap.nvim',
	config = function()
		df.now(function() require('neominimap.api').disable() end) -- start closed
		df.map('n', '<C-m>', ':Neominimap Toggle<CR>', df.ko)
	end
}
