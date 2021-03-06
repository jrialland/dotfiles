" +---------------------------------------------------------+
" |General vim settings.                                    |
" +---------------------------------------------------------+
syntax enable
filetype on
set autoindent        " Indented text
set autoread          " Pick up external changes to files
set autowrite         " Write files when navigating with :next/:previous
set backspace=indent,eol,start
set belloff=all       " Bells are annoying
set infercase         " Smart casing when completing
set ignorecase        " Search in case-insensitively
set smartcase
set incsearch         " Go to search results immediately
set laststatus=2      " We want a statusline
set mouse=a           " Mouse support in the terminal
set mousehide         " Hide mouse when typing text
set nocompatible      " No Vi support
set shiftwidth=4
set smarttab
set synmaxcol=200     " Only syntax highlight for 200 chars (for performance)
set colorcolumn=85    " You should not code after that limit
set t_Co=256          " 256 color support
set tabstop=4
set textwidth=79
set ttyfast
set updatetime=1000
set wildignore+=.git/**,_build/**,build/**,cache/**,node_modules/**,lib/**,log/**,tmp/**
set wildmenu
set wildmode=full
set shell=/bin/bash

" line numbers
set number

" Do not keep backup files
set nowb
set nobackup
set noswapfile
set undofile
set undodir=$HOME/.vim/undodir

" encoding
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

if has('gui_running')
    set background=light
else
    set background=dark
endif

" +---------------------------------------------------------+
" |Plugins installation through vundle                      |
" +---------------------------------------------------------+
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle
" -----------------------------------------------------------
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'mileszs/ack.vim'
Plugin 'sjl/gundo.vim'

" The sparkup vim script is in a subdirectory of this repo called vim.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Plugin 'tpope/vim-commentary'

" Plugin 'altercation/vim-colors-solarized'
" colorscheme solarized
" -----------------------------------------------------------
call vundle#end()
filetype plugin indent on
" End of vundle configuration

" +---------------------------------------------------------+
" |airline configuration                                    |
" +---------------------------------------------------------+
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_theme = 'molokai'

" +---------------------------------------------------------+
" |NERDTree configuration    (:help NERDTree.txt)           |
" +---------------------------------------------------------+
" open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"autocmd BufEnter * if !argc() | NERDTreeMirror | endif
autocmd VimEnter * wincmd w

" map control+t to toogle action 
map <C-n> :NERDTreeToggle<CR>

" +---------------------------------------------------------+
" |YouCompleteMe/ultisnips                                  |
" +---------------------------------------------------------+
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" +---------------------------------------------------------+
" |ctrlp configuration                                      |
" +---------------------------------------------------------+
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" +---------------------------------------------------------+
" |ack.vim                                                  |
" +---------------------------------------------------------+
" sudo apt-get install silversearcher-ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" +---------------------------------------------------------+
" |gundo  (https://sjl.bitbucket.io/gundo.vim/)             |
" +---------------------------------------------------------+
if has('python3')
    let g:gundo_prefer_python3 = 1
endif
nnoremap <F5> :GundoToggle<CR>


" -----------------------------------------------------------
" Treat .json files as .js
autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
" Treat .md files as Markdown
autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

" Gradle stuff (groovy)
augroup gradle
    " Remove all other autocmds.
    autocmd!
    " Set syntax highlighting to Groovy
    autocmd BufRead,BufNewFile *.gradle set filetype=groovy
    " We seem to be using tabs for these
    autocmd Filetype groovy setlocal nolist
    autocmd Filetype groovy setlocal noexpandtab
augroup end

" -----------------------------------------------------------
" Python commands.
augroup python
    " Remove all other autocmds.
    autocmd!
    " Automatically turn tabs into spaces in .py files.
    autocmd Filetype python retab!
    " Make tab characters stand out
    autocmd Filetype python setlocal list
    " This errorformat isn't perfect for either pep8 or pylint, but it works
    " decently for both.
    autocmd Filetype python setlocal errorformat=%f:%l%m
augroup end!


" see also http://www.terminally-incoherent.com/blog/2013/05/06/vriting-vim-plugins-in-python/


