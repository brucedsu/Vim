"-----------------
" Interface
"-----------------
set guifont=Menlo\ for\ Powerline:h15
highlight Comment cterm=italic
set guicursor+=a:blinkon0               " disable blinking
set guioptions-=T

"-----------------
" Local
"-----------------
if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
        source ~/.gvimrc.local
    endif
endif
