
if exists('g:done_init_autocmds')
  finish
endif

" Help in new tabs
function! s:Helptab()
  if &buftype ==? 'help' || &filetype ==? 'man'

    " Don't try to mess up float win
    if has('nvim')
      try
        let l:config = nvim_win_get_config(0)
      catch /E5555/
        let l:config = {}
      endtry
      if has_key(l:config, 'relative') && l:config.relative !=# ''
        return 0
      endif
    endif

    if &columns > 180
      wincmd L
    else
      wincmd J
    endif
    nnoremap <buffer> q <cmd>q<cr>
    nnoremap <buffer> O <cmd>only<cr>
  endif
endfunction

function! s:WipeNoFileBuffers() abort
  let l:bufs = filter(range(1, bufnr('$')), 'bufexists(v:val) && '
        \ . 'empty(getbufvar(v:val, "&buftype")) && '
        \ . '!(filereadable(bufname(v:val)) || getbufvar(v:val, "&modified"))')
  if !empty(l:bufs)
    execute 'bwipeout! ' join(l:bufs)
  endif
endfunction

function! s:is_neovide(chan_id) abort
  let l:info = nvim_get_chan_info(a:chan_id)
  return has_key(l:info, 'client') &&
        \ has_key(l:info.client, 'name') &&
        \ nvim_get_chan_info(a:chan_id).client.name ==# 'neovide'
endfunction

function! s:load_neovide_init() abort
  if s:is_neovide(v:event.chan) && filereadable(expand('~/.vim/init/neovide.vim'))
    source ~/.vim/init/neovide.vim
  endif
endfunction

augroup init_autocmds
  autocmd!

  if has('nvim')
    autocmd FocusGained * silent! call jobstart(['alnum_async'])
  else
    autocmd FocusGained * silent! call job_start(['alnum_async'])
  endif

  if exists('##UIEnter')
    autocmd UIEnter * call s:load_neovide_init()
  endif

  autocmd BufWinEnter *.txt call s:Helptab()
  autocmd BufWinEnter *.jax call s:Helptab()
  autocmd FileType    man   call s:Helptab()

  " autocmd FileType markdown.lsp-hover set filetype=help

  if exists('##TermOpen')
    " start insert mode when opening or switching to a terminal (neovim)
    " autocmd TermOpen * startinsert
  elseif exists('##TerminalOpen')
    autocmd TerminalOpen * startinsert
  endif

  " no signcolumn for cmdwin
  autocmd CmdwinEnter [:\/\?=] setlocal signcolumn=no

  autocmd FileType * execute 'setlocal dict+=~/.vim/words/' . &filetype . '.txt'
  autocmd BufRead,BufNewFile */.grc/* setfiletype conf

  " ....................Z SHELL.......................
  autocmd BufRead,BufNewFile $HOME/.zsh/*,$HOME/dotfiles/*zsh*/*
        \ if expand('%:h') !~# '\.git' &&
        \      expand('%:e') ==# '' &&
        \      join(flatten([
        \        getline(1, &modelines),
        \        getline(line('$') - &modelines, line('$'))
        \      ]))
        \        !~? '\(vim\|vi\|ex\):' |
        \          setfiletype zsh |
        \ endif

  autocmd FileType zsh silent! unlet b:is_sh

  autocmd FileType go setlocal sw=4 ts=4 sts=4 noet

  " Weird how this is needed
  autocmd BufEnter *.ebnf ++once runtime after/syntax/ebnf/*.vim

  autocmd BufRead,BufNewFile {launch,task,tsconfig}.json,*/.vscode/*.json set ft=jsonc

  " autocmd QuitPre * call s:WipeNoFileBuffers()

  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline

augroup END

let g:done_init_autocmds = 1

