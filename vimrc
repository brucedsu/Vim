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

filetype on
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
set hidden

let mapleader = ","
nmap <Leader>l :set list!<CR>
nnoremap <Space> za
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a
nmap <Leader>q :q<CR>
nmap <Leader>q1 :q!<CR>
nmap <Leader>v :vi ~/.vimrc<CR>
nmap <Leader>s :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
if OSX()
    nmap <D-[> <<
    nmap <D-]> >>
    vmap <D-[> <gv
    vmap <D-]> >gv
else
    nmap <A-[> <<
    nmap <A-]> >>
    vmap <A-[> <gv
    vmap <A-]> >gv
endif
nmap <Leader>' :bn<CR>
nmap <Leader>; :bp<CR>
nmap <Leader>d :bd<CR>
nmap <Leader>d1 :bd!<CR>
nmap <Leader>e :e#<CR>
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
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
nmap <Leader>n :tabnew<CR>

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
