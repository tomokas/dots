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
colorscheme monokai
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

autocmd BufWritePre * :%s/\s\+$//e

highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
match OverLength '\%81v.*'

call pathogen#infect()

if has("gui_running")
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

" Don't litter the working dir with swapfiles
set backupdir=.backup,/tmp,.
set directory=.backup,/tmp,.

" Status line
set laststatus=2
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%01v,%01l/%L][%p%%]\ %{fugitive#statusline()}
