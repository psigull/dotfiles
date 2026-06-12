-- 🪐 colour scheme of theseus

vim.cmd([[highlight clear]])
if vim.fn.exists("syntax_on") then
    vim.cmd([[syntax reset]])
end
vim.g.colors_name = "theseus"

-- palette
local bg       = '#181819' -- primary terminal background
local fg       = '#CDCFD2' -- primary text foreground
local panel    = '#222427' -- floating menus, popups, and tabline background
local panel_sel = '#2e3b41' -- active item background highlights
local muted    = '#76787D' -- gray text for comments, hints, and line numbers
local cursor   = '#3E4246' -- current line / selection block background

-- accent colours
local pink     = '#EE7987' -- keywords, conditionals, types
local green    = '#82FBC6' -- secondary types, special tokens
local teal     = '#B7FDE2' -- vonstants
local blue     = '#89E2FC' -- functions
local ice_blue = '#B1C8FA' -- operators
local yellow   = '#F9ECA8' -- strings
local pastel_g = '#A7C1AA' -- specialized line elements
local gray_alt = '#E0E0E0' -- identifiers

-- git / diff colours
local diff_add = '#405e21'
local diff_del = '#5e3737'
local diff_chg = '#44506a'

-- helper function for native highlighting
local hl = function(group, options)
    vim.api.nvim_set_hl(0, group, options)
end

-- editor ui surfaces
hl('Normal',       { fg = fg, bg = bg })
hl('NonText',      { fg = muted, bg = bg })
hl('SignColumn',   { bg = bg })
hl('ColorColumn',  { bg = cursor })
hl('CursorLine',   { bg = cursor })
hl('Visual',       { bg = cursor })
hl('LineNr',       { fg = pastel_g })

-- floating windows and popups
hl('Pmenu',        { fg = fg, bg = panel })
hl('PmenuSel',     { fg = cursor, bg = fg })
hl('PmenuThumb',   { fg = fg, bg = panel })
hl('WildMenu',     { fg = fg, bg = panel })

-- tabs and statuslines
hl('StatusLine',   { fg = cursor, bg = gray_alt })
hl('TabLine',      { fg = muted, bg = panel_sel })
hl('TabLineFill',  { fg = muted, bg = panel_sel })
hl('TabLineSel',   { fg = cursor, bg = gray_alt })

-- diffs
hl('DiffAdd',      { bg = diff_add })
hl('DiffDelete',   { bg = diff_del })
hl('DiffChange',   { bg = diff_chg })

-- syntax highlighting
hl('Comment',      { fg = muted })
hl('Constant',     { fg = teal })
hl('String',       { fg = yellow })
hl('Identifier',   { fg = gray_alt })
hl('Function',     { fg = blue })
hl('Keyword',      { fg = pink })
hl('Conditional',  { fg = pink })
hl('Repeat',       { fg = pink })
hl('Operator',     { fg = ice_blue })
hl('Type',         { fg = green, italic = true })
hl('Error',        { fg = pink })

-- treesitter
local links = {
    ['TSComment']       = 'Comment',
    ['TSConditional']   = 'Conditional',
    ['TSConstant']      = 'Constant',
    ['TSField']         = 'Constant',
    ['TSFloat']         = 'Number',
    ['TSFuncMacro']     = 'Macro',
    ['TSFunction']      = 'Function',
    ['TSKeyword']       = 'Keyword',
    ['TSLabel']         = 'Type',
    ['TSNamespace']     = 'TSType',
    ['TSNumber']        = 'Number',
    ['TSOperator']      = 'Operator',
    ['TSParameter']     = 'Constant',
    ['TSProperty']      = 'TSField',
    ['TSRepeat']        = 'Repeat',
    ['TSString']        = 'String',
    ['TSType']          = 'Type',
    ['Whitespace']      = 'Comment',
    ['Macro']           = 'Function',
    ['CursorLineNr']    = 'Identifier',
}

for syntax_group, target_group in pairs(links) do
    vim.api.nvim_set_hl(0, syntax_group, { link = target_group })
end
