"-----------------
" Environment
"-----------------
set nocompatible

silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
endfunction

"-----------------
" Bundles
"-----------------
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

"-----------------
" General
"-----------------
syntax on
set autoread
set autowrite
set backspace=2
set clipboard=unnamed
set hidden
set history=1000
set scrolloff=3
set showcmd
set showmode
set visualbell
set wildmenu
if has("autocmd")
    autocmd BufWritePost ~/.vimrc source $MYVIMRC
    autocmd BufWritePost ~/.vimrc.bundle source $MYVIMRC
    autocmd BufWritePost ~/.gvimrc source ~/.gvimrc
endif

"-----------------
" Text Editing
"-----------------
" show
set number
set ruler
if v:version >= 703
    set colorcolumn=72
endif

" folding
set foldmethod=syntax
set foldlevelstart=99

" encoding
set encoding=utf-8

" indentation
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set smarttab

if has("autocmd")
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd Filetype markdown setlocal wrap linebreak nolist spell
    autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets
endif

" wrapping
set nowrap
command! -nargs=* Wrap setlocal wrap linebreak nolist

" invisibles
set listchars=tab:▸\ ,trail:▫,eol:¬

" searching
set ignorecase
set hlsearch
set incsearch
set smartcase

" template
if has("autocmd")
    " autocmd BufNewFile *.java 0r ~/.vim/skeleton/Java
endif

" return to last edit position when opening files
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif"`'")"'")

"-----------------
" Interface
"-----------------
" colors
if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    set background=dark
    colorscheme solarized
endif

" font
if ($TERM_PROGRAM == 'iTerm.app')
    highlight Comment cterm=italic
endif

" hightlight current position
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" status line
set laststatus=2

" disable automatically inserting comment at the beginning of next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"-----------------
" Mapping
"-----------------
let mapleader = ","

" list
nmap <leader>l :set list!<CR>

" quiting
nmap <leader>qq :q<CR>
nmap <leader>q1 :q!<CR>

" saving
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a

" folding
nnoremap <Space> za
vnoremap <Space> za

" config
nmap <leader>vv :tabedit $MYVIMRC<CR>
nmap <leader>vb :tabedit ~/.vimrc.bundles<CR>
nmap <leader>vg :tabedit ~/.gvimrc<CR>
nmap <leader>so :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" indentation
if OSX()
    nmap <D-[> <<
    nmap <D-]> >>
    vmap <D-[> <gv
    vmap <D-]> >gv
endif

" buffer
nmap <leader>. :bp<CR>
nmap <leader>/ :bn<CR>
nmap <leader>d :bd<CR>
nmap <leader>d1 :bd!<CR>
nmap <leader>e :e#<CR>

" window
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
nmap <leader>nw :new<CR>
nmap <leader>nv :vnew<CR>

" tab
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
nmap <leader>0 :tablast<CR>
nmap <leader>nt :tabnew<CR>
nmap <leader>tt :tabedit<Space>
nmap <leader>; :tabprev<CR>
nmap <leader>' :tabnext<CR>

" search
nnoremap <CR> :nohl<CR>

" make
nmap <leader>m :w<CR>:make<CR>
nmap <leader>mc :make clean<CR>

" editing
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
nmap <leader>ew :e %%
nmap <leader>es :sp %%
nmap <leader>ev :vsp %%
nmap <leader>et :tabe %%

" navigation
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
nmap <silent> <leader>sp :set spell!<CR>

" formatting
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call Preserve("normal gg=G")<CR>
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

"-----------------
" Plugin
"-----------------
" snipmate
" let g:snips_author = "DeiSu <deisu@brucedsu.com>"

" Ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"

" neocomplete / neocomplcache
if has("lua")
    " neocomplete
    let g:acp_enableAtStartup            = 0
    let g:neocomplete#enable_at_startup  = 1
    let g:neocomplete#enable_smart_case  = 1
    let g:neocomplete#enable_camel_case  = 1
    let g:neocomplete#max_list           = 15
    let g:neocomplete#enable_auto_select = 1

    " ------ dictionary ------
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " ------ keyword ------
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " ------ mappings ------
    inoremap <expr><C-y> neocomplete#close_popup()
    inoremap <expr><C-e> neocomplete#cancel_popup()
    " inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
    " inoremap <expr><S-tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"
endif

" text bubbling with unimpaired
nmap <C-Up> [e
nmap <C-Down> ]e
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Stupid EasyMotion
map <leader>w <leader><leader>w
map <leader>W <leader><leader>W

" nerdcommenter
let NERDSpaceDelims=1
let NERDCompactSexyComs=1
nmap /// <leader>c<Space>
vmap /// <leader>c<Space>

" tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>
nmap <leader>a/ :Tabularize ////<CR>
vmap <leader>a/ :Tabularize ////<CR>
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

" indentLine
let g:indentLine_char = "│"

"rainbow_parentheses
nmap <leader>cp :RainbowParenthesesToggle<CR>

" NERDTree
let NERDTreeIgnore=['\.class$']
nmap <leader>[ :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" tagbar
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['▸', '▾']
nmap <leader>] :TagbarToggle<CR>
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store

" Ctrp
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
nmap <leader>p :CtrlP<CR>
nmap <leader>b :CtrlPBuffer<CR>

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme                      = 'powerlineish'
let g:airline_enable_branch              = 1
let g:airline_enable_syntastic           = 1
let g:airline_powerline_fonts            = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" SingleRun
nmap <leader>r :SCCompileRun<CR>

" ConqureTerm
nmap <leader>tb :ConqueTermVSplit bash<CR>
nmap <leader>tz :ConqueTermVSplit zsh<CR>

" a.vim
nmap <leader>aa :A<CR>
nmap <leader>as :AS<CR>
nmap <leader>av :AV<CR>

"-----------------
" Local
"-----------------
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
