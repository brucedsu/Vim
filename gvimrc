" ---------------------------- Modeline and Notes ---------------------------- {
" vim: tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
" vim: foldlevel=0 foldmarker={,} foldmethod=marker
" vim: foldtext=deisufunc#DotVimsFoldText()
"    ____       _ ____                          _
"   |  _ \  ___(_) ___| _   _        __ ___   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |_____ / _` \ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____| (_| |\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \__, | \_/ |_|_| |_| |_|_|  \___|
"                                   |___/
"
" DeiSu's personal gvimrc.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }
" -------------------------------- Interface --------------------------------- {

set guifont=Menlo\ for\ Powerline:h14
highlight Comment cterm=italic

" with this, the gui (gvim and macvim) now doesn't have the toolbar, the left
" and right scrollbars and the menu.
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=M

" }
" ---------------------------------- Local ----------------------------------- {

if filereadable(expand("~/.gvimrc.local"))
    source ~/.gvimrc.local
endif

" }
