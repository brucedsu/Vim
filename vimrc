" Modeline and Notes {
" vim: ts=4 sts=4 sw=4 tw=80 foldlevel=0 foldmarker={,} foldmethod=marker foldtext=VimConfigFileFoldText()
"     ____       _ ____                   _
"    |  _ \  ___(_) ___| _   _     __   _(_)_ __ ___  _ __ ___
"    | | | |/ _ \ \___ \| | | |____\ \ / / | '_ ` _ \| '__/ __|
"    | |_| |  __/ |___) | |_| |_____\ V /| | | | | | | | | (__
"    |____/ \___|_|____/ \__,_|      \_/ |_|_| |_| |_|_|  \___|
"
" DeiSu's personal vimrc.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }

" Environment {

    " don't bother with vi compatibility
    set nocompatible

    " terminal {
        if !deisufunc#WINDOWS()
            set shell=/bin/zsh
        endif
        set ttyfast
        set ttyscroll=3
        set lazyredraw
    " }

    " ruby path if using RVM
    " let g:ruby_path = system('rvm current')

" }

" Plugins {

    " leaders should be set before source plugins file
    let mapleader      = ","
    let maplocalleader = "\\"

    if filereadable(expand("~/.vim.plugins"))
        source ~/.vim.plugins
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
    " set spelllang=en
    " autocmd BufRead,BufNewFile *.md,*.txt setlocal spell
    nnoremap <silent> <Leader>ss :set spell!<CR>

    " split: S is covered by cc
    nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

    " keep the cursor in place while joining lines
    nnoremap J mzJ`z

    " jump to current file's directory
    nnoremap <Leader>cd :cd %:p:h<CR>

    " return to last edit position when opening files
    autocmd BufReadPost *
              \ if line("'\"") > 0 && line("'\"") <= line("$") |
              \   exe "normal! g`\"" |
              \ endif"`'")"'")

    " quick editing
    nnoremap <Leader>vv :vi $MYVIMRC<CR>
    nnoremap <Leader>vb :vi ~/.vim.plugins<CR>
    nnoremap <Leader>vg :vi ~/.gvimrc<CR>
    nnoremap <Leader>so :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo '$MYVIMRC reloaded >^.^<'"<CR>

" }

" Editor {

    " Wrapping {
        set nowrap
        command! -nargs=* Wrap setlocal wrap linebreak nolist
        autocmd Filetype markdown setlocal wrap linebreak nolist
    " }

    " Invisibles {
        set listchars=tab:▸\ ,trail:▫,eol:¬
        nnoremap <Leader>l :set list!<CR>

        " remove trailing spaces before saving
        autocmd BufWritePre * :call deisufunc#Preserve("%s/\\s\\+$//e")

        " manually remove trailing spaces
        nnoremap _$ :call deisufunc#Preserve("%s/\\s\\+$//e")<CR>
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

        if deisufunc#OSX()
            nnoremap <D-[> <<
            nnoremap <D-]> >>
            vnoremap <D-[> <gv
            vnoremap <D-]> >gv
        endif

        " reindent
        nnoremap _= :call deisufunc#Preserve("normal gg=G")<CR>
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

        " use space to toggle folding
        nnoremap <Space> za
        vnoremap <Space> za

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

" Product {

    " save before make
    nnoremap <Leader>mm :w<CR>:make<CR>
    nnoremap <Leader>mc :make clean<CR>

" }

" Interface {

    " Colorscheme {
        " use solarized as default
        if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
            colorscheme solarized
        else
            colorscheme desert
        endif

        call deisufunc#SetBackground()

        " use dark in terminals
        if $TERM_PROGRAM =~ "iTerm" || $TERM_PROGRAM =~ "Apple_Terminal"
          set background=dark
        endif
    " }

    " Font {
        " use italic for comments in iTerm
        if ($TERM_PROGRAM =~ 'iTerm')
            highlight Comment cterm=italic
        endif
    " }

    " Number & Ruler & Colorcolumn {
        set number
        set relativenumber
        set ruler
        if v:version >= 703
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
        elseif $TERM_PROGRAM =~ "iTerm"
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
    nnoremap <CR> :nohl<CR>

    " keep search matches in the middle of the window
    nnoremap * *zzzv
    nnoremap # #zzzv
    nnoremap n nzzzv
    nnoremap N Nzzzv

    " matchit
    runtime macros/matchit.vim
    map <tab> %

    " delete characters untill end of the line
    nnoremap D d$

    " wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk
    noremap <down> gj
    noremap <up> gk

    " begining and end of line
    noremap H ^
    noremap L $
    vnoremap L g_

    " disable arrow keys
    noremap <left> <nop>
    noremap <right> <nop>
    noremap <up> <nop>
    noremap <down> <nop>

    " power scroll
    if deisufunc#OSX()
      nnoremap <D-k> 15gk
      nnoremap <D-j> 15gj
    endif

" }

" File {

    " rename file
    nnoremap <Leader>rn :call deisufunc#RenameFile()<CR>

" }

" Buffer {

    set autoread
    set autowrite
    set hidden
    set undolevels=1000

    " Open {
        cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
        nmap <Leader>ew :e %%
        nmap <Leader>es :sp %%
        nmap <Leader>ev :vsp %%
        nmap <Leader>et :tabe %%
        nmap <Leader>tt :tabedit<Space>
    " }

    " Save {
        nnoremap <C-s> :w<CR>
        inoremap <C-s> <Esc>:w<CR>a

        " allow us to save a file we don't have permission to
        " *after* we have already opened it
        cnoremap w!! w !sudo tee % >/dev/null

        " save when losing focus
        au FocusLost * :silent! wall
    " }

    " Quit {
        " :Q to quit (should be default)
        command! Q q
        nnoremap <Leader>qq :q<CR>
        nnoremap <Leader>q1 :q!<CR>

    " }

    " Delete {
        nnoremap <Leader>dd :bd<CR>
        nnoremap <Leader>DD :ene<CR>:bw #<CR>
    " }

    " Navigate {
        nnoremap <Leader>. :bp<CR>
        nnoremap <Leader>/ :bn<CR>
        " switch to alternative buffer
        nnoremap <Leader>e :e#<CR>
    " }

    " count word
    nnoremap <Leader>cw :echo deisufunc#CountWord() . " Words"<CR>

" }

" Window {

    set splitright

    " create
    nnoremap <Leader>nw :new<CR>
    nnoremap <Leader>nv :vnew<CR>

    " navigate
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k

    " resize
    nnoremap <Leader>= <C-w>=
    nnoremap \| <C-w>\|
    nnoremap _ <C-w>_
    nnoremap + 4<C-w>>
    nnoremap - 4<C-w><

" }

" Tab {

    " Create
    nnoremap <Leader>nt :tabnew<CR>

    " Navigate
    nnoremap <Leader>1 1gt
    nnoremap <Leader>2 2gt
    nnoremap <Leader>3 3gt
    nnoremap <Leader>4 4gt
    nnoremap <Leader>5 5gt
    nnoremap <Leader>6 6gt
    nnoremap <Leader>7 7gt
    nnoremap <Leader>8 8gt
    nnoremap <Leader>9 9gt
    nnoremap <Leader>0 :tablast<CR>
    nnoremap <Leader>; :tabprev<CR>
    nnoremap <Leader>' :tabnext<CR>

" }

" Local {

    if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
    endif

" }

