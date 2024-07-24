
let s:nvim = has('nvim')

set guifont=Hack\ Nerd\ Font

if s:nvim
  let g:python3_host_prog = '~/.virtualenv/pynvim/bin/python3'
endif

let g:loaded_matchit = 1
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

let g:vimsyn_folding = 'afP'
let g:vimsyn_embed = 'lPr'
let g:rst_syntax_code_list = {
    \ 'nim':    ['nim'],
    \ 'vim':    ['vim'],
    \ 'java':   ['java'],
    \ 'cpp':    ['cpp', 'c++'],
    \ 'lisp':   ['lisp'],
    \ 'php':    ['php'],
    \ 'python': ['python'],
    \ 'perl':   ['perl'],
    \ 'sh':     ['sh'],
    \ }

let g:loaded_matchparen = 1
let g:rst_use_emphasis_colors = 1
let g:sh_fold_enabled = 7
let g:sh_minlines = 500
let g:zsh_fold_enabled = 1

augroup init_vim_gui
  autocmd!
  if exists('##UIEnter')
    autocmd UIEnter let $COLORTERM = 'truecolor'
  elseif exists('##GUIEnter')
    autocmd GUIEnter let $COLORTERM = 'truecolor'
  endif
augroup END

augroup vimrc
  autocmd!
augroup END

" <Leader> is the key to become a NINJA
let g:mapleader = "\<Space>"
" <localleader> is whut?
let g:maplocalleader = '_'

function! Load_Init(target) abort
  " if !exists('g:init_d')
  "   return 0
  " endif

  if filereadable(g:init_d[a:target])
    execute 'source ' . g:init_d[a:target]
  endif
endfunction
let g:init_d = {}
let g:init_d['root']     = expand('~/.vim/init')
let g:init_d['maps']     = g:init_d['root'] . '/maps.vim'
let g:init_d['commands'] = g:init_d['root'] . '/commands.vim'
let g:init_d['sets']     = g:init_d['root'] . '/sets.vim'
let g:init_d['terminal'] = g:init_d['root'] . '/terminal.vim'
let g:init_d['misc'] = g:init_d['root'] . '/misc.vim'

call Load_Init('sets')
call Load_Init('misc')

colorscheme molokai

augroup init_vim_2
  autocmd!
  autocmd FileType markdown setlocal conceallevel=0
augroup END

call Load_Init('maps')
call Load_Init('commands')
call Load_Init('terminal')

" Used in dein's hook_post_source
let s:custom = expand('~/.vim/custom')

if s:nvim
  function! ApplyCustom(plugin) abort
    let l:share = s:custom . '/share/' . a:plugin . '.vim'
    if filereadable(l:share)
      execute 'source ' . l:share
    endif
    let l:nvim = s:custom . '/nvim/' . a:plugin . '.vim'
    if filereadable(l:nvim)
      execute 'source ' . l:nvim
    endif
  endfunction
else
  function! ApplyCustom(plugin) abort
    let l:share = s:custom . '/share/' . a:plugin . '.vim'
    if filereadable(l:share)
      execute 'source ' . l:share
    endif
    let l:vim = s:custom . '/vim/' . a:plugin . '.vim'
    if filereadable(l:vim)
      execute 'source ' . l:vim
    endif
  endfunction
endif

" @@@@@@@@@@@@@@@@@@@@@@@@@@ DEIN @@@@@@@@@@@@@@@@@@@@@@@@@@@
if s:nvim
  let g:dein#enable_notification = v:true
  let g:dein#notification_time = v:numbermax
endif
let g:dein#install_github_api_token = getenv('GHT')
let g:dein#types#git#default_protocol = 'ssh'
let g:dein#install_max_processes = 4 " 8 is the default
let g:dein#install_process_timeout = 180 " 120 is the default
let g:dein#types#git#clone_depth = 1
let g:dein#types#git#enable_partial_clone = v:true

let s:dein_dir = resolve(expand('~/.dein_cache'))
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  execute 'set runtimepath+=' . s:dein_repo_dir
endif

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

augroup InitVimDein
  autocmd!
  autocmd VimEnter * call dein#call_hook('post_source')
augroup END

if s:nvim
  lua vim.loader.enable()
endif

" load
if dein#min#load_state(s:dein_dir)
  let s:toml_dir  = expand('~/.dein/')
  let s:toml      = s:toml_dir . 'dein.toml'
  let s:toml_lazy = s:toml_dir . 'dein-lazy.toml'
  let s:toml_ddc  = s:toml_dir . 'ddc.toml'

  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml)
  call dein#load_toml(s:toml_lazy, {'lazy': 1})

  call dein#load_toml(s:toml_ddc)

  if s:nvim
    let s:toml_nvim = s:toml_dir . 'nvim.toml'
    call dein#load_toml(s:toml_nvim)
  else
    let s:toml_vim  = s:toml_dir . 'vim.toml'
    call dein#load_toml(s:toml_vim)
  endif

  call dein#end()
  call dein#save_state()
endif

command! DeinInstallAll call dein#install()

" if dein#check_install()
"   call dein#install()
" endif

" For conceal markers.
" if has('conceal')
"   set conceallevel=2 concealcursor=niv
" endif

" ------------------------------------------------------------
" ################################# Lua ######################################
if s:nvim
  lua require('lua_config')
  lua require('diagnostic_config')
  lua require('my_cmd')
  lua require('my_maps')
  lua require('cdr').init()
  lua require('winleave_sign')
  lua require('dein_utils').init()
endif
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CUSTOM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

execute 'set runtimepath^=' . expand('~/.vim/custom')

call ApplyCustom('fzf.vim')

" vim:foldmethod=indent:

