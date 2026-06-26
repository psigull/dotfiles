local function get_mode_highlight(mode)
    local mode_colors = {
        n = { bg = "#3E4246", fg = "#CDCFD2" },
        i = { bg = "#F9ECA8", fg = "#4E525A" },
        v = { bg = "#89E2FC", fg = "#4E525A" },
        V = { bg = "#89E2FC", fg = "#4E525A" },
        ['\22'] = { bg = "#89E2FC", fg = "#4E525A" },
        c = { bg = "#4E525A", fg = "#EE7987" },
        t = { bg = '#4E525A', fg = "#82FBC6" },
    }
    return mode_colors[mode] or { bg = "#222427", fg = "#CDCFD2" }
end

local function get_git_branch()
    local b_vars = vim.b.gitsigns_status_dict
    if b_vars and b_vars.head and b_vars.head ~= '' then
        return ' ' .. b_vars.head
    end
    return ''
end

_G.df_winbar = function()
    local mode_info = vim.api.nvim_get_mode()
    local mode = mode_info.mode
    local mode_map = {
        n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
        ['\22'] = 'V-BLOCK', c = 'COMMAND', t = 'TERMINAL'
    }
    local mode_name = mode_map[mode] or 'NORMAL'

    local current_colors = get_mode_highlight(mode)
    local base_bg = "#222427"

    -- sync highlight hooks
    vim.api.nvim_set_hl(0, 'ModeActive', { fg = current_colors.fg, bg = current_colors.bg, bold = true })
    vim.api.nvim_set_hl(0, 'ModeSepLeft', { fg = current_colors.bg, bg = base_bg })
    vim.api.nvim_set_hl(0, 'ModeSepRight', { fg = current_colors.bg, bg = base_bg })
    vim.api.nvim_set_hl(0, 'WinbarMid', { fg = "#CDCFD2", bg = base_bg })

    -- 1. left side fixed width block
    local git_str = get_git_branch()
    local git_padded = string.format('%-20s', git_str)

    -- 2. right side fixed width block
    local counts = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local diag_raw = string.format(' %d ⚠ %d', counts, warnings)
    local diag_padded = string.format('%10s', diag_raw)

    -- dynamic filenames and colours
    local file_name = vim.fn.expand('%:t')
    if file_name == '' then file_name = '[empty]' end
    local modified = vim.bo.modified
    local modified_str = modified and ' +' or ''

    local file_fg = "#CDCFD2"
    if modified then
        file_fg = "#89E2FC"
	elseif counts > 0 then
        file_fg = "#EE7987"
    end
    vim.api.nvim_set_hl(0, 'WinbarFile', { fg = file_fg, bg = base_bg, bold = modified })

	local diag_fg = "#CDCFD2"
    if counts > 0 then
        diag_fg = "#EE7987"
    end
	vim.api.nvim_set_hl(0, 'WinbarDiag', { fg = diag_fg, bg = base_bg })


    return '%#ModeActive# ' .. mode_name ..
           ' %#ModeSepLeft# ' ..
		   '%#WinbarMid#' .. git_padded ..
           '%= ' ..                                         -- Balanced Left Spacer
           '%#WinbarFile#' .. file_name .. modified_str ..
           '%= ' ..                                         -- Balanced Right Spacer
           '%#WinbarDiag#' .. diag_padded .. '   %l:%c ' ..
           '%#ModeSepRight#' ..
           '%#ModeActive# %p%% '
end

vim.opt.winbar = "%{%v:lua.df_winbar()%}"

vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.statusline = ''
vim.opt.showmode = false
