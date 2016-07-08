" ---------------------------- Modeline and Notes ---------------------------- {
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
" ---------------------------------- Before ---------------------------------- {

" preferences
let g:deisu_preferences = {}

" complete method
" 1: ycm: YouCompleteMe + UltiSnips
" 2: neocomplete: neocomplete.vim + neosnippets
" 3: neocomplcache (if doesn't have lua): neocomplcache.vim + neosnippets
let g:deisu_preferences.complete_method = 'ycm'

" color scheme
let g:deisu_preferences.color_scheme = 'solarized'

" load additional preferences
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" pick completers
call deisufunc#PickSnippetEngine()
call deisufunc#PickAutocompleter()

" }
" --------------------------------- General ---------------------------------- {

filetype plugin indent on
set history=1000                " store lots of :cmdline and search history
set clipboard=unnamed           " make vim use the system default clipboard
set cmdheight=2                 " number of screen lines to use for the cmd line
set visualbell
set ttyscroll=3
set title                       " show file name in titlebar

" the new regex engine is so slow, use the old one
" consider removing this in the future when the new regex engine becomes faster
if v:version >= 704
  set regexpengine=1
endif

" let vim use system default clipboard
if has('unnamedplus')
  set clipboard=unnamedplus,unnamed
else
  set clipboard=unnamed
endif

" mouse: only enable mouse in MacVimApp
if deisufunc#IsMacVimApp()
  set mouse=a
else
  set mouse=
endif
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

" tmux will send xterm-style keys when its xterm-keys option is on
if deisufunc#Istmux()
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" automatically save all buffers when losing focus
augroup autosave
  autocmd!
  autocmd FocusLost * :silent! wall
augroup END

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

" set filetype
augroup set_filetype
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  " autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets
  autocmd BufNewFile,BufReadPost *vimrc* set filetype=vim
augroup END

" encoding
set encoding=utf-8
set termencoding=utf-8

" spelling
set nospell
set spelllang=en

" set spell base on filetype
augroup set_spell_base_on_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.markdown,*.md,*.txt setlocal spell
augroup END

" set comment string base on filetype
augroup set_comment_string_base_on_filetype
  autocmd!
  autocmd FileType c,cpp,h,mql4 setlocal commentstring=//\ %s
augroup END

" jump to the last known cursor position
augroup jump_to_the_last_known_cursor_position
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" abbreviations
iabbrev @@ brucedsu@gmail.com

" }
" -------------------------------- Formatting -------------------------------- {

" wrap
set nowrap                      " don't wrap long lines

" set wrap base on filetype
augroup set_wrap_base_on_filetype
  autocmd!
  autocmd FileType markdown,md setlocal wrap linebreak
augroup END

" indentation
set expandtab                   " use spaces instead of tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent                  " auto indent new lines
set smartindent
set smarttab

" set indentation base on filetype
augroup set_indentation_base_on_filetype
  autocmd!
  autocmd FileType make,asm setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
  autocmd FileType css,ruby,vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType python setl nosmartindent
augroup END

" toggle paste
set pastetoggle=<F4>

" folding
set foldmethod=syntax
set foldlevelstart=99
set foldtext=deisufunc#BaseFoldText()

" set folding base on filetype
augroup set_folding_base_on_filetype
  autocmd!
  autocmd FileType html,php setlocal foldmethod=indent
augroup END

" preserve folding state
set viewoptions-=options
augroup preserve_folding_state
  autocmd!
  autocmd BufWritePost *
    \| if expand('%') != '' && &buftype !~ 'nofile'
    \|  mkview
    \| endif
  autocmd BufRead *
    \| if expand('%') != '' && &buftype !~ 'nofile'
    \|  silent loadview
    \| endif
augroup END

" remove all trailing spaces before saving
augroup remove_trailing_spaces
  autocmd!
  autocmd BufWritePre * :call deisufunc#Preserve("%s/\\s\\+$//e")
augroup END

" don't insert comment prefix when I hit enter at the end of a commented line
augroup remove_comment_prefix_when_hit_enter
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" }
" ------------------------------ User Interface ------------------------------ {

syntax on
set showcmd                     " show incomplete cmds down the bottom
set noshowmode                  " don't show mode at the bottom
set showmatch
set laststatus=2

" wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignorecase
set wildignore=*.git/*,*tmp/*
set wildignore+=*DS_Store*
set wildignore+=*.pdf,*.zip
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.o,*.a,*.obj,*.swp,*.pyc,*.pyo,*.class

" number and ruler
set number
set relativenumber
set ruler

" colorcolumn
if exists('&colorcolumn')
  set colorcolumn=80

  " filetype based color column
  augroup set_colorcolumn_base_on_filetype
    autocmd!
    autocmd Filetype python setlocal colorcolumn=79
  augroup END
endif

" list
set nolist
set listchars=tab:▸\ ,trail:▫,eol:¬,extends:❯,precedes:❮

" highlight current cursor position
augroup highlight_cursor_position
  autocmd!
  autocmd WinLeave * set nocursorline nocursorcolumn
  autocmd WinEnter * set cursorline cursorcolumn
augroup END
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
" --------------------------------- Plugins ---------------------------------- {

if filereadable(expand("~/.vimrc.plugins"))
  source ~/.vimrc.plugins
endif

" set color scheme after load plugins
set background=dark
call deisufunc#SetColorScheme(g:deisu_preferences.color_scheme)

" }
" ---------------------------------- After ----------------------------------- {

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif

" }
