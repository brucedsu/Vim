" Modeline and Copyright {
" vim: set ts=4 sts=4 sw=4 foldmarker={,} foldlevel=1 foldmethod=marker:
"    ____       _ ____                          _
"   |  _ \  ___(_) ___| _   _        __ ___   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |_____ / _` \ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____| (_| |\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \__, | \_/ |_|_| |_| |_|_|  \___|
"                                   |___/
"
" DeiSu's vim configurations for gui.
" Copyright © 2014 DeiSu. All Rights Reserved.
" }

" Interface {

    " General {
        set guifont=Menlo\ for\ Powerline:h14
        highlight Comment cterm=italic
        set guicursor+=a:blinkon0               " disable blinking
        set guioptions-=T
    " }

" }

" Local {

    " Local GVIMRC {
        if has('gui_running')
            if filereadable(expand("~/.gvimrc.local"))
                source ~/.gvimrc.local
            endif
        endif
    " }

" }
