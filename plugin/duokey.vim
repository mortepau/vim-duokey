" File: duokey.vim
" Authors: Morten Paulsen
" Version: 0.1
" Description: Automatic keyboard switching upon entering/leaving certain modes

scriptencoding utf-8

" TODO: Does not work correctly when switching between Vim instances in separate tmux panes
" TODO: lightline update does not work properly, shows US even when it is NO layout

if exists('g:loaded_duokey') && g:loaded_duokey
    finish
endif

let g:loaded_duokey = 1

if !exists('g:duokey_enable')
    let g:duokey_enable = 1
endif

if !exists('g:duokey_program')
    if has("unix")
        let g:duokey_program = 'setxkbmap'
    elseif has("mac")
        let g:duokey_program = 'undefined'
    elseif has("win32") || has("win64")
        let g:duokey_program = 'undefined'
    else 
        echoerr "Cannot detect your system."
    endif

    if !executable(g:duokey_program)
        echoerr "Need to either set g:duokey_program or install " . g:duokey_program
    endif
endif

if !exists('g:duokey_primary')
    let g:duokey_primary = 'no'
endif

if !exists('g:duokey_secondary')
    let g:duokey_secondary = 'us'
endif

if !exists('s:duokey_using_primary')
    let s:duokey_using_primary = 1
endif

if !exists('s:duokey_insert_mode')
    let s:duokey_insert_mode = 0
endif

function! s:set_insert_mode(val) abort
    let s:duokey_insert_mode = a:val
endfunction

function! s:switch(use_primary) abort
    let l:prev = s:duokey_using_primary

    let s:duokey_using_primary = a:use_primary

    if s:duokey_using_primary
        let l:duokey_layout_name = g:duokey_primary
    else
        let l:duokey_layout_name = g:duokey_secondary
    endif
	
    if l:prev != s:duokey_using_primary
        call system(g:duokey_program . " " . l:duokey_layout_name)
    endif

    doautocmd User DuokeyLayoutChange
endfunction

function! s:set_layout(use_primary) abort
    if !g:duokey_enable
        return
    endif

    if s:duokey_insert_mode || a:use_primary
        call s:switch(1)
    else
        call s:switch(0)
    endif
endfunction

function! DuoKeyCurrentLayout() abort
    return s:duokey_using_primary ? g:duokey_primary : g:duokey_secondary
endfunction

augroup DuoKey
    autocmd!
    autocmd VimEnter * call s:set_layout(0)
    autocmd InsertEnter * call s:set_insert_mode(1)
    autocmd InsertLeave * call s:set_insert_mode(0)
    autocmd InsertLeave,FocusGained,CmdlineLeave * call s:set_layout(0)
    autocmd InsertEnter,FocusLost,CmdlineEnter,VimLeave * call s:set_layout(1)
augroup end
