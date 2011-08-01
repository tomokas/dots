" Don't emulate vi
set nocompatible

" Proper backspace
set backspace=start,indent,eol

" w sees underscore as a delimiter
set iskeyword-=_
set iskeyword-=.

" Interface
syntax enable
set title
set number
set ruler
set showcmd
set showmode
colorscheme desert
filetype plugin on
set showbreak=>>\ 
set showmatch

" Search
set ignorecase 
set smartcase  
set hlsearch   
set incsearch  

" Spacing
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Misc
set autochdir

" Plugins
" Toggle NERDTree
"nmap <silent> <C-D> :NERDTreeToggle<CR>

autocmd BufWritePre *.py :%s/\s\+$//e

highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
match OverLength '\%81v.*'

