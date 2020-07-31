" Unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor
tnoremap <Esc> <C-\><C-n>

" Ctrl+hjkl to move between splits
for key in ['h', 'j', 'k', 'l']
  " Move out of insert mode when switching splits
  exe "imap <c-" . key . "> <Esc><c-w>" . key
  exe "map <c-" . key . "> <c-w>" . key
endfor

" Match up to iterm2 sending escape sequence
nnoremap <F6> :tabprevious<CR>
nnoremap <F7> :tabnext<CR>

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


" Swapfiles not in working directory
set backupdir=.backup,/tmp,.
set directory=.backup,/tmp,.


" Plugins
" -------
let g:python3_host_prog = '/Users/tom/.pyenv/versions/neovim/bin/python'
let g:python_host_prog = '/Users/tom/.pyenv/versions/neovim2/bin/python'

call plug#begin('~/.vim/plugged')
Plug 'sjl/gundo.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'inside/vim-search-pulse'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" Plugs without configurations
Plug 'vim-scripts/python.vim'
Plug 'henrik/vim-indexed-search'
Plug 'jaromero/vim-monokai-refined'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'tell-k/vim-autoflake'

" For FZF
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

call plug#end()

nnoremap <F5> :GundoToggle<CR>

" Indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0

colorscheme Monokai-Refined

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
let g:syntastic_python_checkers = ['flake8']


let g:syntastic_check_on_open=1
let g:syntastic_python_flake8_args='--ignore=E701,E261,E127,E128'
let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': ['python', 'jsx'],
    \ 'passive_filetypes': ['html'],
\}


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

let g:autoflake_remove_all_unused_imports=1
let g:autoflake_disable_show_diff=1

set mouse=a

" Semshi
let g:semshi#error_sign_delay = 1.0
nmap <S-Tab> :Semshi goto name prev<CR>

nmap <c-p> :FZF ~/dev/styleme/<cr>
nmap <c-o> :FZF ~/dev/<cr>
nmap <c-i> :FZFGit <cr>
nmap <Tab> :Semshi goto name next<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
