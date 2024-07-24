
if exists('g:done_init_highlight')
  finish
endif

if has('nvim')
  augroup InitHighlights_on_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=300}
  augroup END
endif

" ******************************* T A B L I N E *********************************

function! s:TabLineSelRed()
  highlight TabLineSel guifg='#f04128'
endfunction
function! s:TabLineSelGreen()
  highlight TabLineSel guifg='#28fc32'
endfunction
function! s:TabLineSelBlue()
  highlight TabLineSel guifg='#0663f9'
endfunction
function! s:TabLineSelMagenta()
  highlight TabLineSel guifg='#f628ba'
endfunction
function! s:TabLineSelYellow()
  highlight TabLineSel guifg='#e7e55a'
endfunction

function! s:TabLineSelSwitch()
  let l:current_mode = mode()
  if     l:current_mode ==# 'n'
    call s:TabLineSelBlue()
  elseif l:current_mode ==? 'v'
    call s:TabLineSelMagenta()
  elseif l:current_mode ==? "\<c-v>"
    call s:TabLineSelMagenta()
  elseif l:current_mode ==# 'i'
    call s:TabLineSelGreen()
  elseif l:current_mode ==# 'c'
    call s:TabLineSelYellow()
  elseif l:current_mode ==# 'R'
    call s:TabLineSelRed()
  endif
endfunction

if exists('##SafeState')
  augroup TabLineSelColor
    autocmd!
    autocmd SafeState * call s:TabLineSelSwitch()
  augroup END
else

  if has('nvim')
    if exists('##ModeChanged')
      augroup TabLineSelColor_ModeChanged
        autocmd ModeChanged *:* call s:TabLineSelSwitch()
        autocmd BufWinEnter *   call s:TabLineSelSwitch()
      augroup END
      inoremap <c-c> <esc>`^
    else
      nnoremap v v<cmd>call <sid>TabLineSelSwitch()<cr>
      nnoremap V V<cmd>call <sid>TabLineSelSwitch()<cr>
      " InsertLeave doesn't happen when <c-c> is pressed (differs from <esc>)
      nnoremap <c-v> <c-v><cmd>call <sid>TabLineSelSwitch()<cr>
      vnoremap <esc> <esc><cmd>call <sid>TabLineSelSwitch()<cr>
      inoremap <c-c> <esc><cmd>call <sid>TabLineSelSwitch()<cr>
      noremap  <c-c> <esc><cmd>call <sid>TabLineSelSwitch()<cr>
    endif
    nnoremap :      <cmd>call <sid>TabLineSelYellow()<cr>:
    nnoremap /      <cmd>call <sid>TabLineSelYellow()<cr>/\v
    nnoremap ?      <cmd>call <sid>TabLineSelYellow()<cr>?\v
  endif

  augroup TabLineSelColor
    autocmd!

    " autocmd CursorMoved     * call s:TabLineSelSwitch()
    " autocmd CursorMovedI    * call s:TabLineSelGreen()
    autocmd CompleteChanged * call s:TabLineSelGreen()
    autocmd MenuPopup       * call s:TabLineSelGreen()

    if !exists('##ModeChanged')
      " Doesn't work with Switch
      autocmd InsertEnter     * call s:TabLineSelGreen()
      autocmd InsertLeave     * call s:TabLineSelSwitch()
      autocmd CmdlineEnter    * call s:TabLineSelYellow()
      autocmd CmdlineChanged  * call s:TabLineSelYellow()
      " This runs before leave
      autocmd CmdlineLeave    * call s:TabLineSelBlue()
    endif
  augroup END
endif

" **************************** C O L O R S C H E M E *****************************
augroup TransparentBG
  autocmd!
  autocmd   ColorScheme * highlight Search           ctermbg=cyan  guibg=#73fbfd
  " autocmd   ColorScheme * highlight CursorLine       ctermbg=233   guibg=#111111

  " autocmd   ColorScheme * highlight Underlined       ctermfg=none  guifg=none
  autocmd   ColorScheme * highlight clear CursorLine
  autocmd   ColorScheme * highlight CursorLine       cterm=underline gui=underline

  autocmd   Colorscheme * highlight Tabline          ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight TablineFill      ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight Normal           ctermbg=NONE  guibg=NONE

  " autocmd Colorscheme * highlight Terminal ctermbg=NONE guibg=NONE
  autocmd   Colorscheme * highlight StatusLine       ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight StatusLineTerm   ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight WildMenu         ctermbg=NONE  guibg=NONE
  autocmd   ColorScheme * highlight Pmenu            ctermbg=NONE  guibg=NONE
  autocmd   ColorScheme * highlight NormalFloat      ctermfg=252   guifg=#f8f8f2 ctermbg=NONE  guibg=NONE
  autocmd   ColorScheme * highlight ErrorMsg         ctermbg=NONE  guibg=NONE

  autocmd   Colorscheme * highlight NonText          ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight LineNr           ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight Folded           ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight EndOfBuffer      ctermbg=NONE  guibg=NONE
  autocmd   Colorscheme * highlight SignColumn       ctermbg=NONE  guibg=NONE

  " autocmd   VimLeave    * let &t_me="\<Esc>]50;CursorShape=1\x7"

  " @@@@@@@ Cursor @@@@@@
  autocmd   Colorscheme * highlight CustomCursorN    guifg=#000000 guibg=#0663f9
  autocmd   Colorscheme * highlight CustomCursorI    guifg=#000000 guibg=#28fc32
  autocmd   Colorscheme * highlight CustomCursorV    guifg=#000000 guibg=#f628ba
  autocmd   Colorscheme * highlight CustomCursorC    guifg=#000000 guibg=#e7e55a

  if has('nvim')
    autocmd Colorscheme * highlight MsgArea          guifg=#ddfefe
    autocmd Colorscheme * highlight clear            TermCursor
    autocmd Colorscheme * highlight TermCursor       guibg=#8294ff

    " XXX:
    "   Some extra hi-links that might be missing in colorscheme files
    autocmd Colorscheme * highlight link @text.note    Todo
    autocmd Colorscheme * highlight link @text.warning WarningMsg
    autocmd Colorscheme * highlight link @text.danger  WarningMsg " ErrorMsg?

    autocmd Colorscheme * highlight DiagnosticError ctermfg=1  guifg=Red
    autocmd Colorscheme * highlight DiagnosticWarn  ctermfg=3  guifg=Orange
    autocmd Colorscheme * highlight DiagnosticInfo  ctermfg=4  guifg=LightBlue
    autocmd Colorscheme * highlight DiagnosticHint  ctermfg=7  guifg=LightGrey
    autocmd Colorscheme * highlight DiagnosticOk    ctermfg=10 guifg=LightGreen
  endif

  if $TERM_PROGRAM =~? 'iTerm\.app' && !exists('$TMUX')
    autocmd VimLeave    * highlight CustomCursorN    guifg=#000000 guibg=#8294ff
  endif
" highlight Cursor  guifg=#000000 guibg=#61d1eb
" highlight iCursor guifg=#000000 guibg=#28fc32
" #0663f9 #f628ba #e7e55a

augroup END

let g:done_init_highlight = 1

