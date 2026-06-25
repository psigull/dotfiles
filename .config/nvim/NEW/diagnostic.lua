vim.diagnostic.config({
	virtual_text = false,    -- Keep code lines clean
	underline = true,        -- Subtle line text highlight
	signs = true,            -- Use your merged sign numbers column
	update_in_insert = false, -- Never flash errors while typing
	severity_sort = true, -- what does this do?
})

-- Pure ASCII/Demoscene/tracker retro indicator accents for merged number column
local signs = { Error = "•", Warn = "»", Hint = "·", Info = "›" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- in keybindings: Fetch the error message in a clean floating window under the cursor
df.map("n", "<leader>le", vim.diagnostic.open_float, df.ko)


-- fix autocommenting
df.autocmd("FileType", { pattern = "*", callback = function()
	vim.schedule(function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end)
end})
