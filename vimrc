" Unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
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

let mapleader = ','

set nocompatible
set autochdir
set scrolloff=10
set wildmenu
set wildmode=list:longest,full
set showcmd
set colorcolumn=80

set backspace=start,indent,eol

" Disable toobar in gvim
set guioptions-=T

" Interface
syntax enable
set title
set number
set ruler
set showcmd
set showmode
set showbreak=>>\
set showmatch
set nostartofline
set tabpagemax=100
set laststatus=2

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
autocmd FileType css set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2|set listchars=tab:>-,trail:_ list
autocmd FileType scss set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2|set listchars=tab:>-,trail:_ list
set nosmartindent

colorscheme Monokai-Refined

" Swapfiles not in working directory
set backupdir=.backup,/tmp,.
set directory=.backup,/tmp,.


" Plugins
" -------

call plug#begin('~/.vim/plugged')
Plug 'sjl/gundo.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'inside/vim-search-pulse'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'scrooloose/syntastic' " pip install flake8
Plug 'ervandew/supertab'
Plug 'davidhalter/jedi-vim'
" Plugs without configurations
Plug 'vim-scripts/python.vim'
Plug 'henrik/vim-indexed-search'
Plug 'jaromero/vim-monokai-refined'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" For FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Plug 'Shougo/neosnippet.vim'        " Snippets Engine
" Plug 'Shougo/deoplete.nvim'         " Autocompletion Engine (neovim)
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/neosnippet'
" Plug 'Shougo/neosnippet-snippets'
call plug#end()

nnoremap <F5> :GundoToggle<CR>

" Indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=236

" Search pulse
let g:vim_search_pulse_mode = 'pattern'


" Fugitive
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%01v,%01l/%L][%p%%]\ %{fugitive#statusline()}


" Easymotion
map <Leader> <Plug>(easymotion-prefix)
map <Leader>w <Plug>(easymotion-bd-w)


" Syntastic
let g:syntastic_check_on_open=1
let g:syntastic_python_flake8_args='--ignore=E701,E261,E127,E128'
let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': ['python'],
    \ 'passive_filetypes': ['html'],
\}


" Supertab

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabLongestHighlight = 0


" Jedi
let g:jedi#popup_on_dot = 0


" let g:deoplete#enable_at_startup = 1

let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

function! FZFGit()
    " Remove trailing new line to make it work with tmux splits
    let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    if !v:shell_error
        lcd `=directory`
        call fzf#run({
            \ 'dir': directory,
            \ 'down': '40%'
            \ })
    else
        FZF
    endif
endfunction
command! FZFGit call FZFGit()

map <c-p> :FZF ~/dev/styleme/<cr>
map <c-o> :FZF ~/dev/<cr>

" let g:fzf_layout = {}

" Custom functions
" ----------------
function! ReflowArgs (text)
    let mx = '^\( *\)\(.*\)(\(.*\))$'
    let l = matchstr(a:text, mx)

    let spacing = substitute(l, mx, '\1', '')
    let fname = substitute(l, mx, '\2', '')
    let params_raw = substitute(substitute(l, mx, '\3', ''), ' ', '', 'g')

    let params = join(map(split(params_raw, ","), 'spacing . "    " . v:val . ","'), "\r")

    return spacing . fname . "(\r" . params . "\r" . spacing . ")"
endfunction

map <leader>R :.,.s/.*/\=ReflowArgs(submatch(0))/g<CR>:noh<CR>
