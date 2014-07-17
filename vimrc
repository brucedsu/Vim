"  Modeline and Copyright {
"  vim: set ts=4 sts=4 sw=4 tw=0 foldmarker={,} foldlevel=1 foldmethod=marker:
"     ____       _ ____                   _
"    |  _ \  ___(_) ___| _   _     __   _(_)_ __ ___
"    | | | |/ _ \ \___ \| | | |____\ \ / / | '_ ` _ \
"    | |_| |  __/ |___) | |_| |_____\ V /| | | | | | |
"    |____/ \___|_|____/ \__,_|      \_/ |_|_| |_| |_|
"
"  DeiSu's personal vimrc.
"  Copyright © 2014 DeiSu. All Rights Reserved.
" }

" Environment {

    " Platforms {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible
        if !WINDOWS()
            set shell=/bin/zsh
        endif
    " }

" }

" Bundle {
    if filereadable(expand("~/.vimrc.bundles"))
      source ~/.vimrc.bundles
    endif
" }

" General {
    syntax on
    set backspace=indent,eol,start
    set clipboard=unnamed
    set history=1000
    set pastetoggle=<F2>
    set scrolloff=3
    set showcmd
    set showmode
    set visualbell
    set wildmenu
    let mapleader = ","

    " removes the delay when hitting esc in insert mode in terminal
    set noesckeys
    set ttimeout
    set ttimeoutlen=1

    " don't wait so long for the next keypress
    set ttimeoutlen=500
" }

" Editing {

    " Filetype {
        autocmd BufNewFile,BufReadPost *.md set filetype=markdown
        autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets
    " }

    " Encoding {
        set encoding=utf-8
    " }

    " Spelling {
        set spelllang=en
        autocmd BufRead,BufNewFile *.md,*.txt setlocal spell
        nmap <silent> <Leader>ss :set spell!<CR>
    " }

    " Searching {
        set ignorecase
        set hlsearch
        set incsearch
        set smartcase
        nnoremap <CR> :nohl<CR>
    " }

    " Position {
        " return to last edit position when opening files
        autocmd BufReadPost *
              \ if line("'\"") > 0 && line("'\"") <= line("$") |
              \   exe "normal! g`\"" |
              \ endif"`'")"'")
    " }

" }

" Editor {

    " Wrapping {
        set nowrap
        command! -nargs=* Wrap setlocal wrap linebreak nolist
        autocmd Filetype markdown setlocal wrap linebreak nolist
    " }

    " Invisibles {
        set listchars=tab:▸\ ,trail:▫,eol:¬
        nmap <Leader>l :set list!<CR>

        " remove trailing spaces before saving
        autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

        " manually remove trailing spaces
        nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
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
        autocmd FileType make setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
        autocmd FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

        if OSX()
          nmap <D-[> <<
          nmap <D-]> >>
          vmap <D-[> <gv
          vmap <D-]> >gv
        endif
        " reindent
        nmap _= :call Preserve("normal gg=G")<CR>

    " }

    " Folding {
        set foldmethod=syntax
        set foldlevelstart=99
        set foldcolumn=3

        " ft based folding
        autocmd FileType php,html setlocal foldmethod=indent

        " preserve folding state
        set viewoptions-=options
        augroup vimrc
            autocmd BufWritePost *
            \   if expand('%') != '' && &buftype !~ 'nofile'
            \|      mkview
            \|  endif
            autocmd BufRead *
            \   if expand('%') != '' && &buftype !~ 'nofile'
            \|      silent loadview
            \|  endif
        augroup END

        " use space to toggle folding
        nnoremap <Space> za
        vnoremap <Space> za
    " }

    " Comment {
        " don't add insert comment prefix when I hit enter on a comment line
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " }

    " Preserve {
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

" Interface {

    " Colorscheme {
        if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
            colorscheme solarized
            set background=light
        else
            colorscheme desert
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

" Directory {
    set backupdir=~/.tmp
    set directory=~/.tmp

    " jump to current file's directory
    noremap <Leader>cd :cd %:p:h<CR>
"}

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
        nmap <Leader>r :call RenameFile()<CR>
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
        nmap <C-s> :w<CR>
        imap <C-s> <Esc>:w<CR>a

        " allow us to savea file we don't have permission to
        " *after* we have already opened it
        cnoremap w!! w !sudo tee % >/dev/null
    " }

    " Quit {
        " :Q to quit (should be default)
        command! Q q
        nmap <Leader>qq :q<CR>
        nmap <Leader>q1 :q!<CR>
    " }

    " Delete {
        nmap <Leader>dd :bd<CR>
    " }

    " Navigate {
        nmap <Leader>. :bp<CR>
        nmap <Leader>/ :bn<CR>
        " switch to alternative buffer
        " nmap <Leader>e :e#<CR>
    " }

    " Config {
        nmap <Leader>vv :edit $MYVIMRC<CR>
        nmap <Leader>vb :edit ~/.vimrc.bundles<CR>
        nmap <Leader>vg :edit ~/.gvimrc<CR>
        nmap <Leader>so :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
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

        nmap <Leader>cw :echo CountWord() . " Words"<CR>
    " }

" }

" Window {
    set splitright

    " Create {
        nmap <Leader>nw :new<CR>
        nmap <Leader>nv :vnew<CR>
    " }

    " Navigate {
        map <C-h> <C-w>h
        map <C-l> <C-w>l
        map <C-j> <C-w>j
        map <C-k> <C-w>k
    " }

    " Resize {
        nmap <Leader>= <C-w>=
        nmap \| <C-w>\|
        nmap _ <C-w>_
        nmap + 4<C-w>>
        nmap - 4<C-w><
    " }

" }

" Tab {

    " Create {
        nmap <Leader>nt :tabnew<CR>
    " }

    " Navigate {
        nmap <Leader>1 1gt
        nmap <Leader>2 2gt
        nmap <Leader>3 3gt
        nmap <Leader>4 4gt
        nmap <Leader>5 5gt
        nmap <Leader>6 6gt
        nmap <Leader>7 7gt
        nmap <Leader>8 8gt
        nmap <Leader>9 9gt
        nmap <Leader>0 :tablast<CR>
        nmap <Leader>; :tabprev<CR>
        nmap <Leader>' :tabnext<CR>
    "}

" }

" Navigate {

    " Screen Line {
        if OSX()
            nmap <D-h> gh
            nmap <D-j> gj
            nmap <D-k> gk
            nmap <D-l> gl
            nmap <D-4> g$
            nmap <D-6> g^
            vmap <D-h> gh
            vmap <D-j> gj
            vmap <D-k> gk
            vmap <D-l> gl
            vmap <D-4> g$
            vmap <D-6> g^
        endif

        " wrapped lines goes down/up to next row, rather than next line in file.
        noremap j gj
        noremap k gk
        noremap <down> gj
        noremap <up> gk
    "}

    " Power Scroll {
        noremap K 16gk
        noremap J 16gj
    " }

" }

" Make {
    " save before make
    nmap <Leader>mm :w<CR>:make<CR>
    nmap <Leader>mc :make clean<CR>
" }

" Plugin {

    " Vundle {
        nmap <Leader>vi :BundleInstall<CR>
        nmap <Leader>vu :BundleUpdate<CR>
        nmap <Leader>vl :BundleList<CR>
    " }

    " Completion {

        " Ultisnips {
            let g:UltiSnipsExpandTrigger       = "<tab>"
            let g:UltiSnipsJumpForwardTrigger  = "<tab>"
            let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
        " }

        " YoucompleteMe {
            let g:acp_enableAtStartup                          = 0
            let g:ycm_min_num_of_chars_for_completion          = 1
            let g:ycm_collect_identifiers_from_tags_files      = 1
            let g:ycm_autoclose_preview_window_after_insertion = 1

            " cycle
            let g:ycm_key_list_select_completion          = ['<C-n>', '<Down>']
            let g:ycm_key_list_previous_completion        = ['<C-p>', '<Up>']

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

    " }

    " Navigation {

        " easymotion {
            map \ <Plug>(easymotion-prefix)
            map <Leader>w <Plug>(easymotion-bd-w)
            map <Leader>W <Plug>(easymotion-bd-W)
            map <Leader>j <Plug>(easymotion-j)
            map <Leader>k <Plug>(easymotion-k)
        " }

        " a.vim {
            nmap <Leader>aa :A<CR>
            nmap <Leader>as :AS<CR>
            nmap <Leader>av :AV<CR>
        " }

    " }

    " Editing {

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

        "rainbow_parentheses {
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

    " }

    " IDE {

        " NERDTree {
            let NERDTreeIgnore        = ['\.class$', '\.git', '\.svn', '\.DS_Store', '\.o']
            let NERDTreeShowBookmarks = 1
            let NERDTreeShowHidden    = 1
            let NERDTreeQuitOnOpen    = 1

            " ------ mappings ------
            nmap <Leader>[ :NERDTreeToggle<CR>
            nmap <Leader>f :NERDTreeFind<CR>
        " }

        " ctrp {
            let g:ctrlp_open_multiple_files = 'v'
            let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
            nmap <Leader>p :CtrlP<CR>
            nmap <Leader>b :CtrlPBuffer<CR>
        " }

        " tagbar {
            let g:tagbar_autofocus = 1
            let g:tagbar_sort = 0
            let g:tagbar_compact = 1
            let g:tagbar_iconchars = ['▸', '▾']
            nmap <Leader>] :TagbarToggle<CR>
            set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store
        " }

        " SingleCompile {
            nmap <F3> :SCCompileRun<CR>
            nmap <F4> :SCCompile<CR>
        " }

        " Fugitive {
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
        " }

        " vim-airline {
            set laststatus=2
            let g:airline#extensions#tabline#enabled = 1
            let g:airline_theme                      = 'solarized'
            let g:airline_enable_branch              = 1
            let g:airline_enable_syntastic           = 1
            let g:airline_powerline_fonts            = 1
            if !exists('g:airline_symbols')
              let g:airline_symbols = {}
            endif
        " }

    " }

    " Utilities {

        " ConqureTerm {
            nmap <Leader>tb :ConqueTermVSplit bash<CR>
            nmap <Leader>tz :ConqueTermVSplit zsh<CR>
        " }

    " }

" }

" Local {
    if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
    endif
" }
