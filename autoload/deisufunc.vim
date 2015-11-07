" Modeline and Notes {
" vim: ts=4 sts=4 sw=4 tw=80 foldlevel=0 foldmarker={,} foldmethod=marker foldtext=VimConfigFileFoldText()
"     ____       _ ____               __
"    |  _ \  ___(_) ___| _   _       / _|_   _ _ __   ___
"    | | | |/ _ \ \___ \| | | |_____| |_| | | | '_ \ / __|
"    | |_| |  __/ |___) | |_| |_____|  _| |_| | | | | (__
"    |____/ \___|_|____/ \__,_|     |_|  \__,_|_| |_|\___|
"
" DeiSu's personal functions.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }

" Platforms {

    " OS X
    silent function! deisufunc#OSX()
        return has('macunix')
    endfunction

    " Linux
    silent function! deisufunc#LINUX()
        return has('unix') && !has('macunix') && !has('win32unix')
    endfunction

    " Windows
    silent function! deisufunc#WINDOWS()
        return (has('win16') || has('win32') || has('win64'))
    endfunction

" }

" Startup {

    " install YCM
    function! deisufunc#YCMInstall(info)
        if a:info.status == 'installed' || a:info.force
            !./install.sh --clang-completer
        endif
    endfunction

" }

" Folding {

    " base fold text {
        " excerpt from https://github.com/gpakosz/.vim/blob/vanilla/.vimrc
        silent function! deisufunc#BaseFoldText()
            let l:lpadding = &fdc
            redir => l:signs
            execute 'silent sign place buffer='.bufnr('%')
            redir End
            let l:lpadding += l:signs =~ 'id=' ? 2 : 0

            if exists("+relativenumber")
                if (&number)
                    let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
                elseif (&relativenumber)
                    let l:lpadding += max([&numberwidth, strlen(v:foldstart) + strlen(v:foldstart - line('w0')), strlen(v:foldstart) + strlen(line('w$') - v:foldstart)]) + 1
                endif
            else
                if (&number)
                    let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
                endif
            endif

            " expand tabs
            let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
            let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

            let l:info = ' (' . (v:foldend - v:foldstart) . ')'
            let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
            let l:width = winwidth(0) - l:lpadding - l:infolen

            let l:separator = ' … '
            let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
            let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
            let l:text = l:start . ' … ' . l:end

            " foldtext
            return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
        endfunction
    " }

" }

" Preservation {

    " preserve cursor postion while excuting commands
    function! deisufunc#Preserve(command)
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

" }

" Interface {

    " use background light bewtween 7 am ~ 7pm, otherwise dark
    function! deisufunc#SetBackground()
        if (strftime("%H") >= 7) && (strftime("%H") <= 18)
            set background=light
        else
            set background=dark
        endif
    endfunction

" }

" File {

    " Rename {
        function! deisufunc#RenameFile()
            let old_name = escape(expand('%'), ' ')
            let new_name = escape(input('New file name: ', '', 'file'), ' ')
            if new_name != '' && new_name != old_name
                exec ':saveas ' . new_name
                exec ':silent !rm -rf ' . old_name
                redraw!
            endif
        endfunction
    " }

" }

" Buffer {

    " Count Word {
        function! deisufunc#CountWord()
            let s:old_status = v:statusmsg
            let position = getpos(".")
            exe ":silent normal g\<c-g>"
            let stat = v:statusmsg
            let s:word_count = 0
            if stat != '--No lines in buffer--'
                let s:word_count = str2nr(split(v:statusmsg)[11])
                let v:statusmsg = s:old_status
            end
            call setpos('.', position)
            return s:word_count
        endfunction
    " }

" }

" Plugin {

" }
