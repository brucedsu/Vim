" ---------------------------- Modeline and Notes ---------------------------- {
" vim: tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
" vim: foldlevel=0 foldmarker={,} foldmethod=marker
" vim: foldtext=deisufunc#DotVimsFoldText()
"    ____       _ ____                   _
"   |  _ \  ___(_) ___| _   _     __   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |____\ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \_/ |_|_| |_| |_|_|  \___|
"
" DeiSu's personal vimrc.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }
" ------------------------------- Environment -------------------------------- {

" don't bother with vi compatibility
set nocompatible

" use zsh
set shell=/bin/zsh

" }
" ------------------------------ Before Config ------------------------------- {

if filereadable(expand("~/.vimrc.before"))
    source ~/.vimrc.before
endif

" }
" ------------------------------- Load Plugins ------------------------------- {

if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
endif

" }
" --------------------------------- General ---------------------------------- {

filetype plugin indent on
set history=1000                " store lots of :cmdline and search history
set clipboard=unnamed           " make vim use the system default clipboard
set cmdheight=2                 " number of screen lines to use for the cmd line
set visualbell
set ttyscroll=3
set title                       " show file name in titlebar

" mouse
set mouse=a                     " enables the mouse in all modes
set mousehide                   " hide mouse when typing

" buffer
set autoread                    " automatically read files changed outside vim
set autowrite                   " automatically save before make/exec command
set hidden                      " allows hide buffers with unsaved changes

" better rendering
set ttyfast                     " send more characters to the screen for redrawing
set lazyredraw                  " don't redraw screen while executing a macro
set synmaxcol=256               " don't syntax highlight things after column 256

" vertical/horizontal scroll off
set scrolloff=3                 " at least 3 lines above and below cursor
set sidescrolloff=7
set sidescroll=1

" the longest option makes completion insert the longest prefix of all
" the possible matches
set completeopt=menu,menuone,longest

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" time out on both key codes and mappings
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=10

" automatically save all buffers when losing focus
autocmd FocusLost * :silent! wall

" }
" --------------------------------- Backups ---------------------------------- {

" undo
set undofile                    " store undo states even when files are closed
set undodir=~/.vim/tmp/undo//   " where to save undo histories
set undolevels=1000             " use many levels of undo
set undoreload=10000            " number of lines to save for undo

" backup
set backup                      " backups are nice
set backupdir=~/.vim/tmp/backup//

" swap
set noswapfile                  " no swap files
set directory=~/.vim/tmp/swap//

" make backup folders automatically if they don't exist
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }
" --------------------------------- Editing ---------------------------------- {

" filetype config
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets
autocmd BufNewFile,BufReadPost *vim.plugins* set filetype=vim

" encoding
set encoding=utf-8

" spelling: default is off
set nospell
set spelllang=en

" filetype based spelling
autocmd BufRead,BufNewFile *.markdown,*.md,*.txt setlocal spell

" return to last edit position when opening files
autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif"`'")"'")

" }
" -------------------------------- Formatting -------------------------------- {

set nowrap                      " don't wrap long lines

" indentation
set expandtab                   " use spaces instead of tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent                  " auto indent new lines
set smartindent
set smarttab

" filetype based indentation
autocmd FileType make,asm setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
autocmd FileType css,ruby,vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
au! FileType python setl nosmartindent

" toggle paste
set pastetoggle=<F4>

" folding
set foldmethod=syntax
set foldlevelstart=99
set foldtext=deisufunc#BaseFoldText()

" ft based folding
autocmd FileType html,php setlocal foldmethod=indent

" preserve folding state
set viewoptions-=options
augroup folding
    autocmd BufWritePost *
        \if expand('%') != '' && &buftype !~ 'nofile' |
        \mkview |
        \endif
    autocmd BufRead *
        \if expand('%') != '' && &buftype !~ 'nofile' |
        \silent loadview |
        \endif
augroup END

" remove trailing spaces before saving
autocmd BufWritePre * :call deisufunc#Preserve("%s/\\s\\+$//e")

" don't insert comment prefix when I hit enter at the end of a commented line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" }
" ------------------------------ User Interface ------------------------------ {

set showcmd                     " show incomplete cmds down the bottom
set showmode                    " show mode at the bottom

" status line
set laststatus=2
set statusline=%<[%n]\ %F\ %m%r%y\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %=%-14.(%l,%c%V%)\ %P

" match
set showmatch
runtime macros/matchit.vim

" wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignorecase
set wildignore=*.o,*.obj,*~
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store

" color scheme: use solarized dark as default
syntax on
set background=dark

if filereadable(expand("~/.vim/plugins/vim-colors-solarized/colors/solarized.vim"))
    colorscheme solarized
endif

" italic comment in iTerm2
if $TERM_PROGRAM =~ "iTerm" || $TERM =~ "xterm-256color-italic"
    highlight Comment cterm=italic
endif

" number and ruler
set number
set relativenumber
set ruler

" colorcolumn
if exists('&colorcolumn')
    set colorcolumn=80

    " filetype based color column
    autocmd Filetype python setlocal colorcolumn=79
endif

" list
set nolist
set listchars=tab:▸\ ,trail:▫,eol:¬,extends:❯,precedes:❮

" highlight current cursor position
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

" window
set splitright
set splitbelow

" }
" --------------------------------- Mappings --------------------------------- {

" leaders
let mapleader      = ","
let maplocalleader = "\\"

if filereadable(expand("~/.vimrc.mappings"))
  source ~/.vimrc.mappings
endif

" }
" ------------------------------ Config Plugins ------------------------------ {

if filereadable(expand("~/.vimrc.plugins.conf"))
  source ~/.vimrc.plugins.conf
endif

" }
" ---------------------------------- Local ----------------------------------- {

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" }
