start " enter insert mode by default

set number
set wrap
set autoindent
set mouse=a

set whichwrap+=<,>,[,] " arrow key line wrapping
set clipboard+=unnamedplus " use system clipboard
set hlsearch " highlight search results

" swap paste before/after cursor
nnoremap p P
nnoremap P p

" inSert
nnoremap s i

" down arrow creates new line if there isn't one
nnoremap <expr> <Down> (line('.') == line('$') && getline('$') != '') ? 'o' : 'j'
inoremap <expr> <Down> (line('.') == line('$') && getline('$') != '') ? '<End><CR>' : '<C-O>j'

