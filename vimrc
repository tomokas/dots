" Don't emulate vi
set nocompatible

" Proper backspace
set backspace=start,indent,eol

" w sees underscore as a delimiter
set iskeyword-=_
set iskeyword-=-
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
set nostartofline

" Search
set ignorecase 
set smartcase  
set hlsearch   
set incsearch  

" Spacing
filetype plugin indent on
set autoindent
autocmd FileType python set tabstop=4 shiftwidth=4|set expandtab|set softtabstop=4|set listchars=tab:>-,trail:_ list
autocmd FileType html set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2|set listchars=tab:>-,trail:_ list
autocmd FileType htmldjango set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2|set listchars=tab:>-,trail:_ list
autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2|set listchars=tab:>-,trail:_ list
set nosmartindent

" Vundle Stuff
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'kevinw/pyflakes-vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'sjl/gundo.vim'
Bundle 'henrik/vim-indexed-search'
Bundle 'EasyMotion'

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 2

nnoremap <F5> :GundoToggle<CR>

for prefix in ['i', 'n', 'v']
  " Unbind the cursor keys in insert, normal and visual modes.
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor

endfor

" Ctrl+hjkl to move between splits
for key in ['h', 'j', 'k', 'l']
  " Move out of insert mode when switching splits
  exe "imap <c-" . key . "> <Esc><c-w>" . key
  exe "map <c-" . key . "> <c-w>" . key
endfor

" Misc
set autochdir

autocmd BufWritePre * :%s/\s\+$//e

highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
match OverLength '\%81v.*'

if has("gui_running")
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

" Don't litter the working dir with swapfiles
set backupdir=.backup,/tmp,.
set directory=.backup,/tmp,.

" Status line
set laststatus=2
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%01v,%01l/%L][%p%%]\ %{fugitive#statusline()}
