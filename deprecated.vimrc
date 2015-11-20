" Modeline and Notes {
" vim: ts=4 sts=4 sw=4 tw=80 foldlevel=0 foldmarker={,} foldmethod=marker foldtext=VimConfigFileFoldText()
"    ____       _ ____                  _       _
"   |  _ \  ___(_) ___| _   _        __| |_   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |_____ / _` \ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____| (_| |\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \__,_| \_/ |_|_| |_| |_|_|  \___|
"
" DeiSu's deprecated vimrc, vimrc.plugins, vimrc.plugin.conf and vimrc.mappings
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }

" deprecated vimrc {

  " Cursor {
      " switch cursor shape between vertical bar and box in iTerm
      if exists('$TMUX')
          let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
          let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      else
          let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
          let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
      endif
  " }

" }

" deprecated vimrc.plugins {

    " Completion {
        " too many snippets, blow up the completion menu, wtf
        Plug 'honza/vim-snippets'
    " }

    " Refactor {
        " good plugin, but never used
        Plug 'tommcdo/vim-exchange'
    " }

    " Front End Web Development {
        " CSS
        " take 300ms to load a css file
        Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
        " take 100ms to load and cause lag while scrolling
        Plug 'ap/vim-css-color', { 'for': 'css' }
    " }

    " IDE {
        " almost never used
        " not main stream
        " python: use python-mode to run python code
        " c++/c: use make file
        " everything else: use code runner
        Plug 'xuhdev/SingleCompile'
    "}

    " Utilities {
        " never used
        " not main stream
        Plug 'chilicuil/conque'
    " }

    " Colors {
        " only use solarized
        " sorry to these awesome color schemes
         Plug 'sickill/vim-monokai'
         Plug 'tomasr/molokai'
         Plug 'nelstrom/vim-mac-classic-theme'
         Plug 'noahfrederick/vim-hemisu'
         Plug 'rickharris/vim-blackboard'
    " }

" }

" deprecated vimrc.plugins.conf {

    " Syntastic {
        " special characters cause ruler and colorcolumn twisted
        " just stick to default ones
        let g:syntastic_error_symbol = '✗'
        let g:syntastic_warning_symbol = '⚠'
        let g:syntastic_style_error_symbol = '✠'
        let g:syntastic_style_warning_symbol = '≈'
    " }

    " SingleCompile {
        nnoremap <F3> :SCCompileRun<CR>
        inoremap <F3> <esc>:SCCompileRun<CR>
        nnoremap <F4> :SCCompile<CR>
        inoremap <F4> :<esc>:SCCompile<CR>
    " }

    " conque {
        nnoremap <Leader>tb :ConqueTermVSplit bash<CR>
        nnoremap <Leader>tz :ConqueTermVSplit zsh<CR>
    " }

" }

" deprecated vimrc.mappings {

    " Tab {
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
    " }

" }
