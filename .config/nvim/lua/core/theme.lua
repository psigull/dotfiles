-- the colour scheme of theseus
-- originally by https://github.com/nodlag/godot-theme-vscode
-- converted with https://github.com/arcticlimer/djanho

vim.cmd[[highlight clear]]
local highlight = function(group, bg, fg, attr)
    fg = fg and 'guifg=' .. fg or ''
    bg = bg and 'guibg=' .. bg or ''
    attr = attr and 'gui=' .. attr or ''

    vim.api.nvim_command('highlight ' .. group .. ' '.. fg .. ' ' .. bg .. ' '.. attr)
end

local link = function(target, group)
    vim.api.nvim_command('highlight! link ' .. target .. ' '.. group)
end

local Color0 = '#EE7987'
local Color1 = '#76787D'
local Color10 = '#CDCFD2'
local Color11 = '#222427'
local Color12 = '#2e3b41'
local Color13 = '#623e45'
local Color14 = '#A7C1AA'
local Color15 = '#2C2E32'
local Color2 = '#B7FDE2'
local Color3 = '#89E2FC'
local Color4 = '#82FBC6'
local Color5 = '#cc8fe3'
local Color6 = '#F9ECA8'
local Color7 = '#E0E0E0'
local Color8 = '#B1C8FA'
local Color9 = '#3E4246'

local bg = '#111111' -- terminal bg
highlight('Normal', bg, Color10, nil)
highlight('NonText', bg, Color1, nil)
highlight('SignColumn', bg, nil, nil)

highlight('DiffAdd', '#405e21', nil, nil)
highlight('DiffDelete', '#5e3737', nil, nil)
highlight('DiffChange', '#44506a', nil, nil)

-- highlight('SignColumn', Color11, nil, nil)
-- highlight('Normal', Color11, Color10, nil)
-- highlight('DiffAdd', Color12, nil, nil)
-- highlight('DiffDelete', Color13, nil, nil)
highlight('ColorColumn', Color9, nil, nil)
highlight('Comment', nil, Color1, nil)
highlight('Conditional', nil, Color5, nil)
highlight('Constant', nil, Color2, nil)
highlight('CursorLine', Color9, nil, nil)
highlight('Error', nil, Color0, nil)
highlight('Function', nil, Color3, nil)
highlight('Identifier', nil, Color7, nil)
highlight('Keyword', nil, Color0, nil)
highlight('LineNr', nil, Color14, nil)
highlight('Operator', nil, Color8, nil)
highlight('Pmenu', Color11, Color10, nil)
highlight('PmenuSel', Color10, Color9, nil)
highlight('PmenuThumb', Color11, Color10, nil)
highlight('Repeat', nil, Color5, nil)
highlight('StatusLine', Color7, Color9, nil)
highlight('String', nil, Color6, nil)
highlight('TSPunctDelimiter', nil, Color10, nil)
highlight('TabLine', Color15, Color1, nil)
highlight('TabLineFill', Color15, Color1, nil)
highlight('TabLineSel', Color7, Color9, nil)
highlight('Type', nil, Color0, nil)
highlight('Type', nil, Color4, 'italic')
highlight('Visual', Color9, nil, nil)
highlight('WildMenu', Color11, Color10, nil)

-- link('NonText', 'Comment')
link('Conditional', 'Operator')
link('CursorLineNr', 'Identifier')
link('Macro', 'Function')
link('Operator', 'Keyword')
link('Repeat', 'Conditional')
link('TSComment', 'Comment')
link('TSConditional', 'Conditional')
link('TSConstBuiltin', 'TSVariableBuiltin')
link('TSConstant', 'Constant')
link('TSField', 'Constant')
link('TSFloat', 'Number')
link('TSFuncMacro', 'Macro')
link('TSFunction', 'Function')
link('TSKeyword', 'Keyword')
link('TSLabel', 'Type')
link('TSNamespace', 'TSType')
link('TSNumber', 'Number')
link('TSOperator', 'Operator')
link('TSParameter', 'Constant')
link('TSParameterReference', 'TSParameter')
link('TSProperty', 'TSField')
link('TSPunctBracket', 'MyTag')
link('TSPunctSpecial', 'TSPunctDelimiter')
link('TSRepeat', 'Repeat')
link('TSString', 'String')
link('TSTag', 'MyTag')
link('TSTagDelimiter', 'Type')
link('TSType', 'Type')
link('Whitespace', 'Comment')
