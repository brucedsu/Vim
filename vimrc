" Modeline and Notes {
" vim: ts=4 sts=4 sw=4 tw=80 foldlevel=0 foldmarker={,} foldmethod=marker foldtext=VimConfigFileFoldText()
"    ____       _ ____                   _
"   |  _ \  ___(_) ___| _   _     __   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |____\ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \_/ |_|_| |_| |_|_|  \___|
"
" DeiSu's personal vimrc.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }

" Environment {
    " don't bother with vi compatibility
    set nocompatible

    " terminal {
        if !deisufunc#Windows()
            set shell=/bin/zsh
        endif
        set ttyfast
        set ttyscroll=3
        set lazyredraw
    " }
" }

" Load Plugins {
    if filereadable(expand("~/.vimrc.plugins"))
        source ~/.vimrc.plugins
    endif
" }

" General {

    syntax on
    set synmaxcol=128
    set backspace=indent,eol,start
    set clipboard=unnamed
    set cmdheight=2
    set completeopt=menuone
    set history=1000
    set pastetoggle=<F2>
    set scrolloff=3
    set showcmd
    set showmode
    set visualbell
    set wildmenu
    set laststatus=2

    " leaders
    let mapleader      = ","
    let maplocalleader = "\\"

    " time out on both key codes and mappings
    set timeout
    set timeoutlen=500
    set ttimeout
    set ttimeoutlen=10

    " Backups {
        set backup
        set noswapfile
        set undofile
        set undoreload=10000
        set undodir=~/.vim/tmp/undo//
        set backupdir=~/.vim/tmp/backup//
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

" }

" Editing {
    " filetype
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets
    autocmd BufNewFile,BufReadPost *vim.plugins* set filetype=vim

    " encoding
    set encoding=utf-8

    " spelling
    set spelllang=en
    " autocmd BufRead,BufNewFile *.md,*.txt setlocal spell

    " jump to current file's directory
    nnoremap <Leader>cd :cd %:p:h<CR>

    " return to last edit position when opening files
    autocmd BufReadPost *
              \ if line("'\"") > 0 && line("'\"") <= line("$") |
              \   exe "normal! g`\"" |
              \ endif"`'")"'")
" }

" Editor {

    " Wrapping {
        set nowrap
        command! -nargs=* Wrap setlocal wrap linebreak nolist
        autocmd Filetype markdown setlocal wrap linebreak nolist
    " }

    " Invisibles {
        set listchars=tab:▸\ ,trail:▫,eol:¬

        " remove trailing spaces before saving
        autocmd BufWritePre * :call deisufunc#Preserve("%s/\\s\\+$//e")
    " }

    " Indentation {
        set expandtab
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set autoindent
        set smartindent
        set smarttab

        " filetype based indentation
        autocmd FileType make,asm setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
        autocmd FileType css,ruby,vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
        au! FileType python setl nosmartindent
        " autocmd FileType yacc setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
    " }

    " Folding {
        set foldmethod=syntax
        set foldlevelstart=99

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

        function! VimConfigFileFoldText() " {
            " remove quatation marks and the following space
            return substitute(deisufunc#BaseFoldText(), "\" ", "", "g")
        endfunction
        " }

        set foldtext=deisufunc#BaseFoldText()
    " }

    " Comment {
        " don't insert comment prefix when I hit enter at the end of a commented line
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " }

" }

" Interface {

    " Colorscheme {
        " use solarized as default
        if filereadable(expand("~/.vim/plugins/vim-colors-solarized/colors/solarized.vim"))
            colorscheme solarized
        else
            colorscheme desert
        endif

        set background=dark
    " }

    " Font {
        " use italic for comments in iTerm
        if $TERM_PROGRAM =~ "iTerm" || $TERM =~ "xterm-256color-italic"
            highlight Comment cterm=italic
        endif
    " }

    " Number & Ruler & Colorcolumn {
        set number
        set relativenumber
        set ruler
        if exists('&colorcolumn')
            set colorcolumn=72
        endif
    " }

    " Highlight {
        " hightlight current cursor position
        au WinLeave * set nocursorline nocursorcolumn
        au WinEnter * set cursorline cursorcolumn
        set cursorline cursorcolumn
    " }

    " Cursor {
        " change cursor shape between insert and normal mode in iTerm2.app
        if exists('$TMUX')
            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
        else
            let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
            let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
        endif
    " }

" }

" Searching and Movement {
    set ignorecase
    set smartcase
    set incsearch
    set showmatch
    set hlsearch

    " matchit
    runtime macros/matchit.vim
" }

" Buffer {
    set autoread
    set autowrite
    set hidden
    set undolevels=1000

    " automatically save all buffers when losing focus
    au FocusLost * :silent! wall
" }

" Window {
    set splitright
" }

" Mappings {
    if filereadable(expand("~/.vimrc.mappings"))
      source ~/.vimrc.mappings
    endif
" }

" Config Plugins {
    if filereadable(expand("~/.vimrc.plugins.conf"))
      source ~/.vimrc.plugins.conf
    endif
" }

" Local {
    if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
    endif
" }

