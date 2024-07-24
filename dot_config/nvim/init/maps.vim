scriptencoding utf-8

if exists('g:done_init_maps')
  finish
endif

" He's too dangerous to be left alive.
nnoremap ZZ <nop>
nnoremap ZQ <nop>

nnoremap        <leader>w  :w<cr>:e<cr>
nnoremap        <leader>ee :e %<cr>
nnoremap        <leader>es :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
nnoremap        <leader>el :<c-u>mode<cr>

" XXX This could be done better, I guess.
inoremap <expr> <c-^>      col('.') == col('$') ?
      \                    "\<c-c>:\<c-u>mode\<cr>i" :
      \                    "\<c-c>:\<c-u>mode\<cr>i\<c-o>l"

nnoremap <expr> <leader>8 len(getline(line('.'))) > 80 ?  '080l' : ''

nnoremap <leader>hn <cmd>noh<cr>

" YOUR MOVE !?
xnoremap <nowait> <leader>ll $h
nnoremap <nowait> <leader>ll $
noremap           <leader>0  0
nnoremap          <leader>hh 0
xnoremap <nowait> <leader>hh ^


nmap              <leader>b  %
xmap              <leader>b  %


" Count Dooku
set nrformats=alpha,octal,hex,bin,unsigned

nnoremap +   :execute 'normal! ' . v:count1 . "\<c-a>"<cr>
nnoremap g+ g<c-a>
nnoremap -   :execute 'normal! ' . v:count1 . "\<c-x>"<cr>
nnoremap g- g<c-x>
xnoremap +   <c-a>gv
xnoremap g+ g<c-a>gv
xnoremap -   <c-x>gv
xnoremap g- g<c-x>gv

" disable builtin maps as I keep pressing it by mistake and cause unexpected
" changes
nnoremap <c-a> <nop>
xnoremap <c-a> <nop>
nnoremap <c-x> <nop>
xnoremap <c-x> <nop>


" *****************************************************************
"                         Commander Cody
" *****************************************************************

" XXX could be done better
function! SplitCmdLine() abort
  let l:cmd_line   = getcmdline()
  let l:cmd_len    = len(l:cmd_line)
  let l:cmd_pos    = getcmdpos()
  let l:cmd_after  = l:cmd_line[l:cmd_pos-1 :]
  let l:cmd_before = (l:cmd_pos > 1 ) ? l:cmd_line[: l:cmd_pos-2] : ''
  call setreg('c', l:cmd_after)
  call setcmdpos(l:cmd_len)
  return l:cmd_before
endfunction

cnoremap <c-a> <c-b>
cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-n> <down>
cnoremap <c-p> <up>
cnoremap <c-k> <c-\>eSplitCmdLine()<cr>
cnoremap <c-y> <c-r>c
cnoremap <c-o> <c-f>
cnoremap <c-d> <del>
cnoremap <c-x> <c-r>=expand('%')<cr>

" macrophobia
nnoremap <leader>qm  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" make cursor moves work as you would expect when lines are wrapped.
" nnoremap gg gg
nnoremap j      gj
nnoremap k      gk
nnoremap <down> gj
nnoremap <up>   gk

" reselect pasted text
nnoremap gp `[v`]

" ^ or H
nnoremap <silent>H       :<C-U>call <SID>CarretOrH(v:count1)<CR>
vnoremap <silent><expr>H CarretOrHExpr()
function! s:CarretOrH(amount)
  let l:col = col('.')
  if l:col == 1 || a:amount > 1
    execute 'normal! ' . a:amount . 'H'
  elseif l:col > 1 && a:amount < 2
    normal! ^
  endif
endfunction

function! CarretOrHExpr() abort
  let l:col = col('.')
  let l:result = ''
  if l:col == 1
    let l:result = 'H'
  elseif l:col > 1
    let l:result = '^'
  endif
  return l:result
endfunction

" $ or L
nnoremap <silent>L       :call <SID>DollarOrL(v:count1)<CR>
vnoremap <silent><expr>L DollarOrLExpr()
function! s:DollarOrL(amount)
  let l:col = col('.')
  if a:amount > 1 || col('$') < 2
    execute 'normal! ' . a:amount . 'L'
  elseif a:amount < 2 && l:col == col('$') - 1
    normal! L
  elseif a:amount < 2 && l:col < col('$') - 1
    normal! $
  endif
endfunction

function! DollarOrLExpr()
  let l:col = col('.')
  let l:eol = col('$') - 1
  let l:result = ''
  if l:eol < 2 || l:col >= l:eol
    let l:result = 'L'
  elseif l:col < l:eol
    let l:result = '$'
  endif
  return l:result
endfunction

inoremap m m

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"                    Substitutions
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! ExpandCursorWord() abort
  let l:cursor_word = expand('<cword>')
  return len(l:cursor_word) > 0 ? l:cursor_word : ' '
endfunction

nnoremap <expr> <leader>r ':%sm/\v' . ExpandCursorWord() . '/new/gec' . repeat("\<left>", 8)
nnoremap <leader>R  :%S/<c-r>=ExpandCursorWord()<cr>/new/gvec<left><left><left><left><left><left><left><left>
xnoremap <leader>r  :sm/\v /new/gec<left><left><left><left><left><left><left><left>

nnoremap <leader>uu  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap <leader>dd  :<c-u>execute 'move +'  . v:count1<cr>

let g:AutoPairs = {
      \ '('   :')'  ,
      \ '['   :']'  ,
      \ '{'   :'}'  ,
      \ "'"   :"'"  ,
      \ '"'   :'"'  ,
      \ '`'   :'`'  ,
      \ '```' :'```',
      \ '"""' :'"""',
      \ "'''" :"'''",
      \ '<!--':'-->',
      \ }

augroup AutoPairs
  autocmd!
  autocmd FileType vim let b:AutoPairs = {
      \  '<'   : '>'  ,
      \  '('   : ')'  ,
      \  '['   : ']'  ,
      \  '{'   : '}'  ,
      \  "'"   : "'"  ,
      \  '"'   : '"'  ,
      \  '`'   : '`'  ,
      \  '```' : '```',
      \  '"""' : '"""',
      \  "'''" : "'''",
      \}
augroup END

if has('nvim')
  inoremap   <expr> <c-p> pumvisible()            ? "\<up>"                      :
        \                                           "\<cmd>normal! gk\<cr>"

  imap       <expr> <c-n> pumvisible()            ? "\<down>"                    :
        \                 neosnippet#jumpable()   ? "\<plug>(neosnippet_jump)"   :
        \                                           "\<cmd>normal! gj\<cr>"

  imap       <expr> <c-q> neosnippet#expandable() ? "\<plug>(neosnippet_expand)" :
        \                                           ''

  xmap       <expr> <c-q> neosnippet#expandable() ? "\<plug>(neosnippet_expand_target)" :
        \                                           ''

else
  inoremap   <c-p>  <up>
  imap       <expr> <c-n> neosnippet#expandable() ? "\<plug>(neosnippet_expand)" :
        \                 neosnippet#jumpable()   ? "\<plug>(neosnippet_jump)"   :
        \                                           "\<down>"

  imap       <expr> <c-q> neosnippet#expandable() ? "\<plug>(neosnippet_expand)" :
        \                                           ''

  xmap       <expr> <c-q> neosnippet#expandable() ? "\<plug>(neosnippet_expand_target)" :
        \                                           ''
endif

" ---> I M A P <---
" Trust me. These are useful.
inoremap        <c-b> <left>
inoremap        <c-f> <right>
inoremap        <c-a> <c-o>^
inoremap        <c-k> <c-o>"kD
inoremap        <c-d> <del>
inoremap <expr> <c-y> col('.') > 2 ? "\<left>\<c-o>\"kp" : "\<space>\<c-o>0\<c-\>\<c-o>\"kp\<c-o>0\<c-d>"
" function! I_CTRL_Y() abort
"   let l:cur_pos_save = getcurpos()
"   let l:cur_line = getline(line('.'))
"   let l:killed = getreg('k')
"   let l:col = col('.')
"   let l:lineNo = line('.')
"   if l:col > 2
"     execute "normal! \<left>\"kp"
"   else
"     call setline(l:lineNo, l:cur_line[0 : l:col] . l:killed . l:cur_line[l:col : -1])
"   endif
"   return setpos('.', l:cur_pos_save)
" endfunction

xnoremap > >gv
xnoremap < <gv

" Buffers/Windows
nnoremap mh <cmd>hide<cr>
nnoremap ms <cmd>sp<cr><c-w>j
nnoremap mv <cmd>vs<cr><c-w>l

nnoremap <silent> m9 <cmd>bprev<cr>
nnoremap <silent> m0 <cmd>bnext<cr>
nnoremap <silent> mp <cmd>execute 'normal! ' . v:count1 . 'gT'<cr>
nnoremap <silent> mn <cmd>execute 'normal! ' . v:count1 . 'gt'<cr>

function! TabNextOrNew(count) abort
  let l:tabs = tabpagenr('$')
  if l:tabs < 2
    tabnew
  else
    execute a:count . 'tabnext'
  endif
endfunction

" B]]]

" Use K to show documentation in preview window.
nnoremap <silent> K         <cmd>call Hover_Or_Show_documentation()<cr>
nnoremap <silent> <leader>K <cmd>call Vim_Help()<cr>

function! Hover_Or_Show_documentation()
  if &filetype ==# 'vim'
    try
      LspHover
    catch
      execute 'h ' . expand('<cword>')
    endtry
  elseif &filetype ==# 'help'
    execute 'h ' . expand('<cword>')
  endif
endfunction

function! Vim_Help() abort
  if (index(['vim', 'lua', 'help'], &filetype) >= 0)
    execute 'h '. expand('<cword>')
  endif
endfunction

inoremap <silent> <expr> <space> pumvisible()                  ? "\<space>" :
      \                          exists('b:autopairs_enabled') ? "\<c-]>\<c-r>=AutoPairsSpace()\<cr>" :
      \                                                          "\<space>"

if exists('*complete_info')
  " inoremap <silent> <expr> <cr> ExpandOnCR()
  " function! ExpandOnCR() abort
  "   if complete_info()['selected'] !=# '-1' && neosnippet#expandable()
  "     return "\<c-c>g\<c-h>" . neosnippet#mappings#expand_impl()
  "   elseif pumvisible()
  "     return "\<c-y>\<c-g>u"
  "   endif
  "   return "\<c-g>u\<cr>"
  " endfunction

  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<c-g>u" : "\<cr>"

  " inoremap <expr> <s-tab> complete_info()['selected'] !=# '-1' ? "\<up>"   : "\<s-tab>"
  " inoremap <expr> <tab>   complete_info()['selected'] !=# '-1' ? "\<down>" : "\<tab>"

else
  inoremap <expr> <cr>    pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif

inoremap <expr> <c-e>   pumvisible() ? "\<c-e>" : "\<end>"

command! Zsh belowright vsplit +terminal\ zsh\ -l
nnoremap <leader>Z <cmd>Zsh<cr>

let g:done_init_maps = 1

" vim:foldmethod=indent:
