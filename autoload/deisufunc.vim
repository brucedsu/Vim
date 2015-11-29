" ---------------------------- Modeline and Notes ---------------------------- {
" vim: tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
" vim: foldlevel=0 foldmarker={,} foldmethod=marker
" vim: foldtext=deisufunc#DotVimsFoldText()
"     ____       _ ____               __
"    |  _ \  ___(_) ___| _   _       / _|_   _ _ __   ___
"    | | | |/ _ \ \___ \| | | |_____| |_| | | | '_ \ / __|
"    | |_| |  __/ |___) | |_| |_____|  _| |_| | | | | (__
"    |____/ \___|_|____/ \__,_|     |_|  \__,_|_| |_|\___|
"
" DeiSu's personal functions.
" Copyright © 2014-2015 DeiSu. All Rights Reserved.
" }
" ------------------------------- Environment -------------------------------- {

" OS X
silent function! deisufunc#OSX()
    return has('macunix')
endfunction

" MacVim with gui_running
silent function! deisufunc#MacVim()
    return has('gui_macvim') && has('gui_running')
endfunction

" iTerm2
silent function! deisufunc#iTerm2()
    return $TERM_PROGRAM =~ "iTerm" || $TERM =~ "xterm-256color-italic"
endfunction

" Apple Terminal
silent function! deisufunc#AppleTerminal()
    return $TERM_PROGRAM =~ "Apple_Terminal"
endfunction

" Linux
silent function! deisufunc#Linux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" Windows
silent function! deisufunc#Windows()
    return (has('win16') || has('win32') || has('win64'))
endfunction

" }
" --------------------------------- Startup ---------------------------------- {

" install YCM
function! deisufunc#YCMInstall(info)
    if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer
    endif
endfunction

" }
" --------------------------------- Folding ---------------------------------- {

" base fold text
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

" vim config files folding text
function! deisufunc#DotVimsFoldText()
    " remove quatation marks and the following space
    return substitute(deisufunc#BaseFoldText(), "\" ", "", "g")
endfunction

" }
" ----------------------------------- Run ------------------------------------ {

function! deisufunc#RunCurrentFile()
    let s:run_file_name = @%
    let s:run_file_name_without_extension = expand('%:t:r')
    let s:run_file_type = &filetype

    " generate run command
    let s:run_file_command = "clear && "
    if s:run_file_type == 'cpp'
        let s:run_file_command = s:run_file_command . "g++ " . s:run_file_name .
            \ " -o " . s:run_file_name_without_extension .
            \ " && ./" . s:run_file_name_without_extension
    elseif s:run_file_type == 'c'
        let s:run_file_command = s:run_file_command . "gcc " . s:run_file_name .
            \ " -o " . s:run_file_name_without_extension .
            \ " && ./" . s:run_file_name_without_extension
    elseif s:run_file_type == 'python'
        let s:run_file_command = s:run_file_command . "python3 " . s:run_file_name
    endif

    " open a new window and resize it
    execute 'split'
    call deisufunc#ResizeCurrentWindowHeight(0.5, 10)

    " open VimShell
    execute 'VimShell'
    call feedkeys(s:run_file_command)
    call feedkeys("\<CR>")
endfunction

" }
" ------------------------------- Preservation ------------------------------- {

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
" -------------------------------- Interface --------------------------------- {

" use background light bewtween 7 am ~ 7pm, otherwise dark
function! deisufunc#SetBackgroundBaseOnTime()
    if (strftime("%H") >= 7) && (strftime("%H") <= 18)
        set background=light
    else
        set background=dark
    endif
endfunction

" toggle background of the current color scheme
function! deisufunc#ToggleBG()
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction

function! deisufunc#ResizeCurrentWindowHeight(ratio, min)
    let s:expected_height = winheight(0) * a:ratio
    let s:new_height =  s:expected_height < a:min ? a:min : s:expected_height
    execute "resize".string(s:expected_height)
endfunction

" }
" ----------------------------------- File ----------------------------------- {

" rename current file
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
" ---------------------------------- Buffer ---------------------------------- {

" Count Word
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
" ---------------------------------- Plugin ---------------------------------- {

" }
