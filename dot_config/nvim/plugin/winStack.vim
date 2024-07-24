" Script Name: winStack.vim
" Description: manage a window layout configuration based on two vertical
" splits, one without horizontal splits (main window), the other with several
" horizontal splits (window stack).
" The plugin helps exchange the window on any buffer opened on a split on the stack 
" with the one on the main window (WinUnstack).
" Or move a buffer opened on the main window to the stack (WinStack).
" Quickix items can be opened too on the stack or main window directly from the quickfix list .
"
" 1) Window layout with stack on the right:
" 
" ┌─────────┐──────────┐
" │         │ Stack-1  │
" │         │──────────│
" │  Main   │ Stack-2  │
" │         │──────────│
" │         │ Stack-3  │
" └─────────┘──────────┘
" 
" 2) Window layout with stack on the left:
" let g:windowStack_defaultSide = "left"
" 
" ┌──────────┐─────────┐
" │ Stack-1  │         │
" │──────────│         │
" │ Stack-2  │  Main   │
" │──────────│         │
" │ Stack-3  │         │
" └──────────┘─────────┘
"
" Copyright:   (C) 2019-2020 Javier Puigdevall Garcia
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:  Javier Garcia Puigdevall <javierpuigdevall@gmail.com>
" Contributors:
"
" Dependencies:
"
" Version:      0.0.1
" Changes:
" 0.0.1 	Tue, 21 Feb 20.     JPuigdevall


if exists('g:loaded_winStack')
    finish
endif

let g:loaded_winStack = 1
let s:save_cpo = &cpo
set cpo&vim


"- configuration --------------------------------------------------------------

" Window stack side left or right of the main window
let g:windowStack_defaultSide  = get(g:, 'windowStack_defaultSide', "right")
" Window default stack position: top or bottom of the stack
let g:windowStack_defaultHeigh = get(g:, 'windowStack_defaultHeigh', "bottom")
" Wether quickfix window should be closed or not after selecting an item to be opened on main or stack.
let g:windowStack_closeQuickfix = get(g:, 'windowStack_closeQuickfix', 1)


"- commands -------------------------------------------------------------------

" Stack a window, move it to the window stack.
command! -nargs=0  WinStack       call winStack#stackWindow(g:windowStack_defaultHeigh)

" Unstack a window, move it to the main window split.
command! -nargs=0  WinUnstack     call winStack#unstackWindow(g:windowStack_defaultHeigh)

" Open a test window layout to test the commands.
command! -nargs=0  WinStTest      call winStack#test()

" DEBUG: Change log level verbosity.
command! -nargs=?  WinStv         call winStack#Verbose("<args>")


"- mappings -------------------------------------------------------------------

if !hasmapto('WinStack', 'n')
    nnoremap <unique> <leader>ws  :WinStack<CR>
endif

if !hasmapto('WinUnstack', 'n')
    nnoremap <unique> <leader>wu  :WinUnstack<CR>
endif

" Recomended mappings:
"nmap <unique> <F5>    :WinUnstack<CR>
"nmap <unique> <F6>    :wincmd R<CR>
"nmap <unique> <F8>    :WinStack<CR>


"- abbreviations -------------------------------------------------------------------

" DEBUG: reload plugin
cnoreabbrev _strl <C-R>=winStack#Reload()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo

