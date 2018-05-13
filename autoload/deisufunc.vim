" ---------------------------- Modeline and Notes ---------------------------- {
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
" ------------------------------- Identify OS -------------------------------- {

" Mac OS X
silent function! deisufunc#OnOSX()
  return has('macunix')
endfunction

" Linux
silent function! deisufunc#OnLinux()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" Windows
silent function! deisufunc#OnWindows()
  return (has('win16') || has('win32') || has('win64'))
endfunction

" }
" ------------------------------- Identify App ------------------------------- {

" MacVim app, not MacVim bin running in terminal
silent function! deisufunc#IsMacVimApp()
  return has('gui_macvim') && has('gui_running')
endfunction

" iTerm2
silent function! deisufunc#IsiTerm2()
  return $TERM_PROGRAM =~ "iTerm" || $TERM =~ "xterm-256color-italic"
endfunction

" Apple Terminal
silent function! deisufunc#IsAppleTerminal()
  return $TERM_PROGRAM =~ "Apple_Terminal"
endfunction

" tmux
silent function! deisufunc#Istmux()
  return exists('$TMUX')
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
" --------------------------------- Editing ---------------------------------- {

" inspired by tpope's vim-unimpaired
" TODO: press . to repeat
function! deisufunc#MoveLine(cmd, count)
  silent! execute 'move'.a:cmd.a:count
endfunction

function! deisufunc#MoveLineUp()
  call deisufunc#MoveLine('--', v:count1)
endfunction

function! deisufunc#MoveLineDown()
  call deisufunc#MoveLine('+', v:count1)
endfunction

function! deisufunc#MoveSelectionUp()
  silent! execute "'<,'>move'<--".v:count1
  call feedkeys("gv")
endfunction

function! deisufunc#MoveSelectionDown()
  silent! exe "'<,'>move'>+".v:count1
  call feedkeys("gv")
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
  " save current file
  execute 'update'

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
  " save the last search, and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")

  " execute command
  execute a:command

  " restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" }
" -------------------------------- Interface --------------------------------- {

" set color scheme
function! deisufunc#SetColorScheme(color_scheme)
  exec "colorscheme " . a:color_scheme

  " set vim-airline theme
  if exists('g:loaded_airline')
    let g:airline_theme = a:color_scheme
  endif

  call deisufunc#EnableItalicComment()
endfunction

" use background light bewtween 7 am ~ 7pm, otherwise dark
function! deisufunc#SetBackgroundBaseOnTime()
  if (strftime("%H") >= 7) && (strftime("%H") <= 18)
    set background=light
  else
    set background=dark
  endif
  call deisufunc#EnableItalicComment()
endfunction

" enable italic comment in iTerm2 and MacVim app
function! deisufunc#EnableItalicComment()
  if deisufunc#IsiTerm2() || deisufunc#IsMacVimApp()
    highlight Comment cterm=italic
  endif
endfunction

" toggle background of the current color scheme
function! deisufunc#ToggleBG()
  let s:current_background = &background

  if s:current_background == "dark"
    set background=light
  else
    set background=dark
  endif

  " (re)enable italic comment
  call deisufunc#EnableItalicComment()
endfunction

" resize current window height
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

" count word
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

function! deisufunc#PickSnippetEngine()
  let g:deisu_preferences.snippet_engine = 'ultisnips'

  " if doesn't have python or python3, use neosnippet
  if g:deisu_preferences.complete_method == 'neocomplete' ||
    \ g:deisu_preferences.complete_method == 'neocomplcache' ||
    \ (!has('python') && !has('python3'))
    let g:deisu_preferences.snippet_engine = 'neosnippet.vim'
  endif
endfunction

function! deisufunc#PickAutocompleter()
  let g:deisu_preferences.autocompleter = 'YouCompleteMe'

  if g:deisu_preferences.complete_method == 'neocomplete'
    let g:deisu_preferences.autocompleter = 'neocomplete.vim'
  elseif g:deisu_preferences.complete_method == 'neocomplcache'
    let g:deisu_preferences.autocompleter = 'neocomplcache.vim'
  endif

  " use neocomplcache if doesn't have lua
  if !has('lua') && g:deisu_preferences.autocompleter == 'neocomplete'
    let g:deisu_preferences.autocompleter = 'neocomplcache.vim'
  endif
endfunction

function! deisufunc#LoadCompleters()
  " completers contains two components
  " one is a snippet completion engine,
  " the other is an autocompleter, such as YCM and neocomplete

  " load snippet engine
  call plug#load(g:deisu_preferences.snippet_engine)

  " load snippets repository
  " consider remove this when create my own snippets repository
  if g:deisu_preferences.snippet_engine == 'neosnippet.vim'
    call plug#load('neosnippet-snippets')
  endif

  " load autocompleter
  call plug#load(g:deisu_preferences.autocompleter)

  " enable autocompleter
  if g:deisu_preferences.autocompleter == 'YouCompleteMe'
    if exists('g:loaded_youcompleteme')
      call youcompleteme#Enable()
    endif
  elseif g:deisu_preferences.autocompleter == 'neocomplete.vim'
    if exists('g:loaded_neocomplete')
      exec "NeoCompleteEnable"
    endif
  elseif g:deisu_preferences.autocompleter == 'neocomplcache.vim'
    if exists('g:loaded_neocomplcache')
      exec "NeoComplCacheEnable"
    endif
  endif
endfunction

" }
