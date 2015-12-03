" ---------------------------- Modeline and Notes ---------------------------- {
" vim: tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
" vim: foldlevel=0 foldmarker={,} foldmethod=marker
" vim: foldtext=deisufunc#DotVimsFoldText()
"    ____       _ ____                  _       _
"   |  _ \  ___(_) ___| _   _        __| |_   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |_____ / _` \ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____| (_| |\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \__,_| \_/ |_|_| |_| |_|_|  \___|
"
" DeiSu's deprecated vimrc, vimrc.plugins, vimrc.plugin.conf and vimrc.mappings
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }
" ----------------------------- deprecated vimrc ----------------------------- {

" switch cursor shape between vertical bar and box in iTerm
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
endif

" }
" ------------------------- deprecated vimrc.plugins ------------------------- {

" Completion
" too many snippets, blow up the completion menu, wtf
Plug 'honza/vim-snippets'

" Editing
" bind tmux prefix to <C-a>
" never used
Plug 'tpope/vim-speeddating'

" Refactor
" good plugin, but never used
Plug 'tommcdo/vim-exchange'

" Front End Web Development
" CSS
" take 300ms to load a css file
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
" take 100ms to load and cause lag while scrolling
Plug 'ap/vim-css-color', { 'for': 'css' }

" IDE
" almost never used
" not main stream
" python: use python-mode to run python code
" c++/c: use make file
" everything else: use code runner
Plug 'xuhdev/SingleCompile'

" Utilities
" never used
" not main stream
Plug 'chilicuil/conque'

" can do everything
" but nothing will be done perfectly
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite.vim'

" Colors
" only use solarized
" sorry to these awesome color schemes
 Plug 'sickill/vim-monokai'
 Plug 'tomasr/molokai'
 Plug 'nelstrom/vim-mac-classic-theme'
 Plug 'noahfrederick/vim-hemisu'
 Plug 'rickharris/vim-blackboard'

" }
" ---------------------- deprecated vimrc.plugins.conf ----------------------- {

" YouCompleteMe
" don't really need preview window
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Syntastic
" special characters cause ruler and colorcolumn twisted
" just stick to default signs
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_style_warning_symbol = '≈'

" SingleCompile
nnoremap <F3> :SCCompileRun<CR>
inoremap <F3> <esc>:SCCompileRun<CR>
nnoremap <F4> :SCCompile<CR>
inoremap <F4> :<esc>:SCCompile<CR>

" conque
nnoremap <Leader>tb :ConqueTermVSplit bash<CR>
nnoremap <Leader>tz :ConqueTermVSplit zsh<CR>

" unite.vim
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {
    \ 'start_insert': 1
    \ })

" custom ignores
" .a files are static libraries generated by the archive tool
call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_pattern', join([
    \ '\.git/', 'tmp/', 'RECYCLE\.BIN/', 'plugins/',
    \ '\.DS_Store$', '\.localized$',
    \ '\.pdf$', '\.zip$',
    \ '\.png$', '\.jpg$', '\.gif$',
    \ '\.mp4$',
    \ '\.o$', '\.a$', '\.so$', '\.obj$', '\.swp$', '\.pyc$', '\.pyo$', '\.class$',
    \ 'a\.out$',
    \ ], '\|'))

let g:unite_prompt = '> '
let g:unite_data_directory = '~/.vim/tmp/unite'
let g:unite_source_rec_max_cache_files = 5000
let g:unite_source_grep_max_candidates = 200

" ag is the first choice
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
    let g:unite_source_grep_command = 'ack'
    let g:unite_source_grep_default_opts = '--no-heading --no-color -C4'
    let g:unite_source_grep_recursive_opt = ''
endif

" map space to the prefix for Unite
nnoremap [unite] <Nop>
nmap <Space> [unite]

" general fuzzy search
nnoremap <silent> [unite]<Space> :<C-u>Unite -buffer-name=general buffer file_mru bookmark file_rec/async:!<CR><C-u>

" search buffers
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<CR>

" search files
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async:!<CR>

" yank history
nnoremap <silent> [unite]y :Unite history/yank<CR>

" search lines
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<CR>

" search mappings
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<CR>

" registers
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

" outline (tags)
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -vertical outline<CR>

" }
" ------------------------ deprecated vimrc.mappings ------------------------- {

" Buffer
" arrow keys are used for window navigation
nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>

" Tab
" use these maps for airline commands
" navigate
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

" <Up> and <Down> are used for window navigation
" almost never use tabs
nnoremap <Up> :tabprev<CR>
nnoremap <Down> :tabnext<CR>

" }
