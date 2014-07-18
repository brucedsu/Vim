" vim: tw=80 foldlevel=0 foldmethod=marker
"    ____       _ ____                          _
"   |  _ \  ___(_) ___| _   _        __ ___   _(_)_ __ ___  _ __ ___
"   | | | |/ _ \ \___ \| | | |_____ / _` \ \ / / | '_ ` _ \| '__/ __|
"   | |_| |  __/ |___) | |_| |_____| (_| |\ V /| | | | | | | | | (__
"   |____/ \___|_|____/ \__,_|      \__, | \_/ |_|_| |_| |_|_|  \___|
"                                   |___/
"
" DeiSu's personal gvim.
" Copyright © 2014 DeiSu. All Rights Reserved.

" Interface --------------------------------------------------------------- {{{

set guifont=Menlo\ for\ Powerline:h14
highlight Comment cterm=italic
" disable blinking
" set guicursor+=a:blinkon0
set guioptions-=T

" }}}

" Local ------------------------------------------------------------------- {{{

if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
        source ~/.gvimrc.local
    endif
endif

" }}}
