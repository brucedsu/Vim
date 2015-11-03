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

    " platforms
    silent function! OSX()
        return has('macunix')
    endfunction

    silent function! LINUX()
        return has('unix') && !has('macunix') && !has('win32unix')
    endfunction

    silent function! WINDOWS()
        return (has('win16') || has('win32') || has('win64'))
    endfunction

    " zsh
    if !WINDOWS()
        set shell=/bin/zsh
    endif

" }

" Bundles {

    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif

" }

" General {

    syntax on
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
    nnoremap <Leader>vb :vi ~/.vimrc.bundles<CR>
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
        autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

        " manually remove trailing spaces
        nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>
    " }

    " Indentation {
        set expandtab
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set autoindent
        set smartindent
        set smarttab

        " ft based indentation
        autocmd FileType make,asm setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
        autocmd FileType css,ruby,vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

        if OSX()
            nnoremap <D-[> <<
            nnoremap <D-]> >>
            vnoremap <D-[> <gv
            vnoremap <D-]> >gv
        endif

        " reindent
        nnoremap _= :call Preserve("normal gg=G")<CR>
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

        " fold text
        " excerpt from https://github.com/gpakosz/.vim/blob/vanilla/.vimrc
        function! BaseFoldText() " {
            let l:lpadding = &fdc
            redir => l:signs
            execute 'silent sign place buffer='.bufnr('%')
            redir End
            let l:lpadding += l:signs =~ 'id=' ? 2 : 0

            if exists("+relativenumber")
                if (&number)
                    let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
                elseif (&relativenumber)
                    let l:lpadding += max([&numberwidth, strlen(v:foldstart) + strlen(v:foldstart - line('w0')), strlen(v:foldstart) + strlen(line('w$') - v:foldstart)]) + 1
                endif
            else
                if (&number)
                    let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
                endif
            endif

            " expand tabs
            let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
            let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

            let l:info = ' (' . (v:foldend - v:foldstart) . ')'
            let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
            let l:width = winwidth(0) - l:lpadding - l:infolen

            let l:separator = ' … '
            let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
            let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
            let l:text = l:start . ' … ' . l:end

            " foldtext
            return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
        endfunction
        " }

        function! VimConfigFileFoldText() " {
            " remove quatation marks and the following space
            return substitute(BaseFoldText(), "\" ", "", "g")
        endfunction
        " }
        set foldtext=BaseFoldText()
    " }

    " Comment {
        " don't insert comment prefix when I hit enter at the end of a commented line
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " }

    " Preservation {
        " preserve cursor postion while excuting commands
        function! Preserve(command)
            " Preparation: save the last search, and cursor position
            let _s=@/
            let l = line(".")
            let c = col(".")
            " Do the business:
            execute a:command
            " Clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
    " }

" }

" Product {
    " save before make
    nnoremap <Leader>mm :w<CR>:make<CR>
    nnoremap <Leader>mc :make clean<CR>
" }

" Interface {

    " Colorscheme {
        " use background light bewtween 7 am ~ 7pm, otherwise dark
        function! SetBackground()
            if (strftime("%H") >= 7) && (strftime("%H") <= 18)
                set background=light
            else
                set background=dark
            endif
        endfunction

        " use solarized as default
        if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
            colorscheme solarized
        else
            colorscheme desert
        endif

        call SetBackground()

        " use dark in terminals
        if $TERM_PROGRAM == "iTerm.app" || $TERM_PROGRAM == "Apple_Terminal"
          set background=dark
        endif
    " }

    " Font {
        " use italic for comments in iTerm
        if ($TERM_PROGRAM == 'iTerm.app')
            highlight Comment cterm=italic
        endif
    " }

    " Number & Ruler & Colorcolumn {
        set number
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
        if $TERM_PROGRAM =~ "iTerm"
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
    if OSX()
      nnoremap <D-k> 15gk
      nnoremap <D-j> 15gj
    endif

" }

" File {

    " Rename {
        function! RenameFile()
            let old_name = escape(expand('%'), ' ')
            let new_name = escape(input('New file name: ', '', 'file'), ' ')
            if new_name != '' && new_name != old_name
                exec ':saveas ' . new_name
                exec ':silent !rm -rf ' . old_name
                redraw!
            endif
        endfunction
        nnoremap <Leader>rn :call RenameFile()<CR>
    " }

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

    " Count Word {
        function! CountWord()
            let s:old_status = v:statusmsg
            let position = getpos(".")
            exe ":silent normal g\<c-g>"
            let stat = v:statusmsg
            let s:word_count = 0
            if stat != '--No lines in buffer--'
                let s:word_count = str2nr(split(v:statusmsg)[11])
                let v:statusmsg = s:old_status
            end
            call setpos('.', position)
            return s:word_count
        endfunction

        nnoremap <Leader>cw :echo CountWord() . " Words"<CR>
    " }

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

" Plugin {

    " Vundle {
        nnoremap <Leader>vi :BundleInstall<CR>
        nnoremap <Leader>vu :BundleUpdate<CR>
        nnoremap <Leader>vl :BundleList<CR>
    " }

    " Ultisnips {
        let g:UltiSnipsExpandTrigger       = "<tab>"
        let g:UltiSnipsJumpForwardTrigger  = "<tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
    " }

    " YoucompleteMe {
        let g:acp_enableAtStartup                          = 0
        let g:ycm_min_num_of_chars_for_completion          = 2
        let g:ycm_collect_identifiers_from_tags_files      = 1

        " preview
        let g:ycm_add_preview_to_completeopt                = 0
        let g:ycm_autoclose_preview_window_after_completion = 1
        let g:ycm_autoclose_preview_window_after_insertion  = 1

        " cycle
        let g:ycm_key_list_select_completion   = ['<C-n>']
        let g:ycm_key_list_previous_completion = ['<C-p>']

        " comment
        let g:ycm_complete_in_comments                          = 1
        let g:ycm_collect_identifiers_from_comments_and_strings = 1

        " path
        let $PATH                       = '/usr/local/bin:'.$PATH
        let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

        " enable omni completion
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    " }

    " easymotion {
        nmap \ <Plug>(easymotion-prefix)
        nmap <Leader>w <Plug>(easymotion-bd-w)
        nmap <Leader>W <Plug>(easymotion-bd-W)
        nmap <Leader>j <Plug>(easymotion-j)
        nmap <Leader>k <Plug>(easymotion-k)
    " }

    " a.vim {
        nnoremap <Leader>aa :A<CR>
        nnoremap <Leader>as :AS<CR>
        nnoremap <Leader>av :AV<CR>
    " }

    " nerdcommenter {
        let NERDSpaceDelims=1
        let NERDCompactSexyComs=1
        nmap /// <Leader>c<Space>
        vmap /// <Leader>c<Space>
    " }

    " indentLine {
        let g:indentLine_char                 = '│'
        let g:indentLine_first_char           = '│'
        let g:indentLine_showFirstIndentLevel = 0
        let g:indentLine_faster               = 1
        let g:indentLine_fileTypeExclude      = ['sql']
    " }

    " rainbow_parentheses {
        nmap <F6> :RainbowParenthesesToggle<CR>
    " }

    " gundo {
        nnoremap <F5> :GundoToggle<CR>
    " }

    " tabular {
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:\zs<CR>
        vmap <Leader>a: :Tabularize /:\zs<CR>
        nmap <Leader>a/ :Tabularize ////<CR>
        vmap <Leader>a/ :Tabularize ////<CR>
        inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
        function! s:align()
            let p = '^\s*|\s.*\s|\s*$'
            if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
                let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
                let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
                Tabularize/|/l1
                normal! 0
                call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
            endif
        endfunction
    " }

    " vim-unimpaired {
        " text bubbling with unimpaired
        nmap <C-Up> [e
        nmap <C-Down> ]e
        vmap <C-Up> [egv
        vmap <C-Down> ]egv
    " }

    " NERDTree {
        let NERDTreeIgnore        = ['\.class$', '\.git', '\.svn', '\.DS_Store', '\.o']
        let NERDTreeShowBookmarks = 1
        let NERDTreeShowHidden    = 1
        let NERDTreeQuitOnOpen    = 1
        nnoremap <Leader>[ :NERDTreeToggle<CR>
        nnoremap <Leader>f :NERDTreeFind<CR>
        nnoremap <Leader>x :NERDTreeCWD<CR>
    " }

    " ctrp {
        let g:ctrlp_open_multiple_files = 'v'
        let g:ctrlp_custom_ignore = {
                  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.png$\|\.dmg$\|\.jpg$\|\.jpeg$\|\.gif$\|\.pdf$' }
        nnoremap <Leader>p :CtrlP<CR>
        nnoremap <Leader>b :CtrlPBuffer<CR>
    " }

    " tagbar {
        let g:tagbar_autofocus = 1
        let g:tagbar_sort = 0
        let g:tagbar_compact = 1
        let g:tagbar_iconchars = ['▸', '▾']
        nnoremap <Leader>] :TagbarToggle<CR>
        set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store
    " }

    " SingleCompile {
        nnoremap <F3> :SCCompileRun<CR>
        inoremap <F3> <esc>:SCCompileRun<CR>
        nnoremap <F4> :SCCompile<CR>
        inoremap <F4> :<esc>:SCCompile<CR>
    " }

    " Fugitive {
        nnoremap <silent> <Leader>gs :Gstatus<CR>
        nnoremap <silent> <Leader>gd :Gvdiff<CR>
        nnoremap <silent> <Leader>gc :Gcommit<CR>
        nnoremap <silent> <Leader>gl :Glog<CR>
        nnoremap <silent> <Leader>gw :Gwrite<CR>
        nnoremap <silent> <Leader>gr :Gread<CR>
        nnoremap <silent> <Leader>grm :Gremove<CR>
        nnoremap <Leader>gm :Gmove<Space>
        nnoremap <silent> <Leader>gb :Gblame<CR>
        nnoremap <Leader>ga :Git add<Space>
        nnoremap <silent> <Leader>ge :Gedit<CR>
    " }

    " vim-airline {
        set laststatus=2
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_theme                      = 'solarized'
        " let g:airline_enable_branch              = 1
        " let g:airline_enable_syntastic           = 1
        let g:airline_powerline_fonts            = 1
        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
    " }

    " ConqureTerm {
        nnoremap <Leader>tb :ConqueTermVSplit bash<CR>
        nnoremap <Leader>tz :ConqueTermVSplit zsh<CR>
    " }

" }

" Local {

    if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
    endif

" }
