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

filetype plugin indent on
syntax on
set number
set listchars=tab:▸\ ,trail:▫,eol:¬
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
if has("autocmd")
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
endif
set autoindent
set smartindent
set smarttab
set hidden
set showcmd
colorscheme desert
autocmd BufWritePost ~/.vimrc source $MYVIMRC
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd Filetype markdown setlocal wrap linebreak nolist spell
set ignorecase
set hlsearch
set incsearch
set smartcase
set foldmethod=syntax
set foldlevelstart=99
set encoding=utf-8

let mapleader = ","
nmap <leader>l :set list!<CR>
nnoremap <Space> za
vnoremap <Space> za
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a
nmap <leader>q :q<CR>
nmap <leader>q1 :q!<CR>
nmap <leader>v :vi $MYVIMRC<CR>
nmap <leader>so :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
if OSX()
    nmap <D-[> <<
    nmap <D-]> >>
    vmap <D-[> <gv
    vmap <D-]> >gv
endif
nmap <leader>' :bn<CR>
nmap <leader>; :bp<CR>
nmap <leader>d :bd<CR>
nmap <leader>d1 :bd!<CR>
nmap <leader>e :e#<CR>
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
nmap <leader>nw :new<CR>
nmap <leader>nv :vnew<CR>
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
nmap <leader>/ :nohl<CR>
nmap <leader>m :w<CR>:make<CR>
nmap <leader>mc :make clean<CR>
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
nmap <leader>ew :e %%
nmap <leader>es :sp %%
nmap <leader>ev :vsp %%
nmap <leader>et :tabe %%
command! -nargs=* Wrap setlocal wrap linebreak nolist
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

" unimpaired.vim
nmap <C-Up> [e
nmap <C-Down> ]e
vmap <C-Up> [egv
vmap <C-Down> ]egv
