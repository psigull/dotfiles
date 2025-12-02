start " enter insert mode by default

set number
set wrap
set mouse=a

set whichwrap+=<,>,[,] " arrow key line wrapping
set clipboard+=unnamedplus " use system clipboard

" swap paste before/after cursor
nnoremap p P
nnoremap P p

" inSert
nnoremap s i

" save and quit
nnoremap <C-s> :w<CR>
vnoremap <C-s> <C-C>:w<CR>
inoremap <C-s> <Esc>:w<CR>a

nnoremap <C-q> :q<CR>
vnoremap <C-q> <Esc>:q<CR>
inoremap <C-q> <Esc>:q<CR>

" copy/cut/paste
nnoremap <C-c> yy
vnoremap <C-c> y
inoremap <C-c> <Esc>yya

nnoremap <C-x> dd
vnoremap <C-x> d
inoremap <C-x> <Esc>dda

nnoremap <C-v> P
vnoremap <C-v> P
inoremap <C-v> <C-o>P

" undo/redo
nnoremap <C-z> u
vnoremap <C-z> <C-C>u
inoremap <C-z> <Esc>ui

nnoremap <C-r> <C-r>
vnoremap <C-r> <C-r>gv
inoremap <C-r> <C-o><C-r>

" down arrow creates new line if there isn't one
nnoremap <expr> <Down> (line('.') == line('$') && getline('$') != '') ? 'o' : 'j'
inoremap <expr> <Down> (line('.') == line('$') && getline('$') != '') ? '<End><CR>' : '<C-O>j'

" blank terminal bg
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE

