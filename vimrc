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
autocmd BufWritePost ~/.vimrc source $MYVIMRC
autocmd BufWritePost ~/.vimrc.bundle source $MYVIMRC
autocmd BufWritePost ~/.gvimrc source ~/.gvimrc

"-----------------
" Text Editing
"-----------------
" filetype
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.snippets set filetype=snippets

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
autocmd FileType make setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
autocmd FileType vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

" wrapping
set nowrap
command! -nargs=* Wrap setlocal wrap linebreak nolist
autocmd Filetype markdown setlocal wrap linebreak nolist spell

" invisibles
set listchars=tab:▸\ ,trail:▫,eol:¬

" searching
set ignorecase
set hlsearch
set incsearch
set smartcase

" return to last edit position when opening files
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif"`'")"'")

"-----------------
" Interface
"-----------------
" colors
" ------ solarized as default ------
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

" change cursor shape between insert and normal mode in iTerm2.app
" if $TERM_PROGRAM =~ "iTerm"
  " let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
  " let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
" endif

"-----------------
" Mapping
"-----------------
let mapleader = ","

" list
nmap <Leader>l :set list!<CR>

" quiting
nmap <Leader>qq :q<CR>
nmap <Leader>q1 :q!<CR>

" saving
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a

" folding
nnoremap <Space> za
vnoremap <Space> za

" config
nmap <Leader>vv :tabedit $MYVIMRC<CR>
nmap <Leader>vb :tabedit ~/.vimrc.bundles<CR>
nmap <Leader>vg :tabedit ~/.gvimrc<CR>
nmap <Leader>so :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" indentation
if OSX()
  nmap <D-[> <<
  nmap <D-]> >>
  vmap <D-[> <gv
  vmap <D-]> >gv
endif

" buffer
nmap <Leader>. :bp<CR>
nmap <Leader>/ :bn<CR>
nmap <Leader>dd :bd<CR>
nmap <Leader>d1 :bd!<CR>
nmap <Leader>e :e#<CR>

" window
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
nmap <Leader>nw :new<CR>
nmap <Leader>nv :vnew<CR>

" tab
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
nmap <Leader>nt :tabnew<CR>
nmap <Leader>tt :tabedit<Space>
nmap <Leader>; :tabprev<CR>
nmap <Leader>' :tabnext<CR>

" search
nnoremap <CR> :nohl<CR>

" make
nmap <Leader>m :w<CR>:make<CR>
nmap <Leader>mc :make clean<CR>

" editing
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
nmap <Leader>ew :e %%
nmap <Leader>es :sp %%
nmap <Leader>ev :vsp %%
nmap <Leader>et :tabe %%

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
nmap <silent> <Leader>sp :set spell!<CR>

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
" Ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"

" neocomplete / neocomplcache
let g:acp_enableAtStartup = 0
if has("lua")
  " neocomplete
  let g:neocomplete#enable_at_startup            = 1
  let g:neocomplete#enable_smart_case            = 1
  let g:neocomplete#enable_camel_case            = 1
  let g:neocomplete#max_list                     = 15
  let g:neocomplete#enable_auto_select           = 1
  let g:neocomplete#auto_completion_start_length = 1

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
  inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"
else
  " neocomplecache
  let g:neocomplcache_enable_at_startup            = 1
  let g:neocomplcache_enable_smart_case            = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_underbar_completion   = 1
  let g:neocomplcache_max_list                     = 15
  let g:neocomplcache_enable_auto_select           = 1

  " ------ dictionary ------
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " ------ keyword ------
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns._ = '\h\w*'

  " ------ mappings ------
  inoremap <expr><C-y> neocomplcache#close_popup()
  inoremap <expr><C-e> neocomplcache#cancel_popup()
  inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"
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
nmap /// <Leader>c<Space>
vmap /// <Leader>c<Space>

" tabular
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

" vim-indent-guide
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

"rainbow_parentheses
nmap <Leader>cp :RainbowParenthesesToggle<CR>

" vim-instant-markdown
set shell=bash\ -i

" NERDTree
let NERDTreeIgnore = ['\.class$', '\.git', '\.svn', '\.DS_Store']
let NERDTreeShowBookmarks   = 1
let NERDTreeShowHidden      = 1
let NERDTreeQuitOnOpen      = 1

" ------ mappings ------
nmap <Leader>[ :NERDTreeToggle<CR>
nmap <Leader>f :NERDTreeFind<CR>
nmap <Leader>x :NERDTreeCWD<CR>

" tagbar
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['▸', '▾']
nmap <Leader>] :TagbarToggle<CR>
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store

" Ctrp
let g:ctrlp_open_multiple_files = 'v'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
nmap <Leader>p :CtrlP<CR>
nmap <Leader>b :CtrlPBuffer<CR>

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme                      = 'solarized'
let g:airline_enable_branch              = 1
let g:airline_enable_syntastic           = 1
let g:airline_powerline_fonts            = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" SingleRun
nmap <Leader>r :SCCompileRun<CR>

" ConqureTerm
nmap <Leader>tb :ConqueTermVSplit bash<CR>
nmap <Leader>tz :ConqueTermVSplit zsh<CR>

" a.vim
nmap <Leader>aa :A<CR>
nmap <Leader>as :AS<CR>
nmap <Leader>av :AV<CR>

"-----------------
" Local
"-----------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
