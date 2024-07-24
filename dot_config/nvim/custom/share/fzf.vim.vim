
" [[[
" ============================= FZF ================================
" Homebrew fzf
let g:fzf_history_dir = '~/.cache/fzf-history'

" If you might possibley happens to be wanting to override it only for vim.
" if has('nvim') || has('gui_running')
"   let $FZF_DEFAULT_OPTS .= ' --inline-info'
" endif
let g:fzf_default_opts_reverse = $FZF_DEFAULT_OPTS . ' --reverse'
let g:fzf_default_opts_default = $FZF_DEFAULT_OPTS . ' --layout=default'

if $FZF_DEFAULT_COMMAND =~? '^\s*fd\(\s+.*\)\?'
  let g:fzf_default_command = $FZF_DEFAULT_COMMAND . shellescape(' --exclude=*.zwc')
  let $FZF_DEFAULT_COMMAND = g:fzf_default_command
endif

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p70%,60%' }
  let $FZF_DEFAULT_OPTS = g:fzf_default_opts_reverse
elseif has('nvim')
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.6 } }
  let $FZF_DEFAULT_OPTS = g:fzf_default_opts_reverse
else
  let g:fzf_layout = { 'down': '~40%'  }
  let $FZF_DEFAULT_OPTS = g:fzf_default_opts_default
endif

let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_tags_command = 'ctags -R'
let g:fzf_preview_window = 'right:50%'
let g:fzf_commands_expect = 'ctrl-e'

let s:pty = !empty($TERM)
let s:fd_base = 'fd --type f --hidden --follow --exclude=.git --exclude=mackup --exclude=\*.zwc '
if s:pty || has('gui_running')
  let s:fd_cmd = s:fd_base . '--color=always '
else
  let s:fd_cmd = s:fd_base . '--color=never '
endif

" *****************************************************
"                       COMMANDS
" *****************************************************
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \   fzf#vim#with_preview({
  \     'options': [ '--cycle', '--info=inline' ],
  \     'source': s:fd_cmd . expand(<q-args>),
  \ }), <bang>0)

" All files
command! -nargs=? -complete=dir AlmostAllFiles
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': s:fd_cmd . '--no-ignore ' . expand(<q-args>)
  \ })))

command! -bang -nargs=0 Cody
  \ call fzf#vim#commands({'options': ['--cycle']}, <bang>0)
command! -bang -nargs=? -complete=dir Dotfiles
  \ call fzf#vim#files('~/dotfiles', fzf#vim#with_preview({'options': ['--cycle', '--info=inline']}), <bang>0)
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --color --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'options':['--cycle'],'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --glob="!.git/*" --glob="!.git_/*" --glob="!mackup/*" --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options':['--cycle']}), <bang>0)
command! -bang -complete=dir -nargs=* LS
  \ call fzf#run(fzf#wrap({'options': ['--cycle'],'source': 'ls -A', 'dir': <q-args>}, <bang>0))
command! -bang -nargs=0 Commits
  \ call fzf#vim#commits({'options':['--cycle']}, <bang>0)

function! RipgrepFzf(query, fullscreen)
  let l:command_fmt = 'rg --hidden --glob="!.git/*" --glob="!.git_/*" --glob="!mackup/*" --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let l:initial_command = printf(l:command_fmt, shellescape(a:query))
  let l:reload_command = printf(l:command_fmt, '{q}')
  let l:spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'. l:reload_command]}
  call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" *****************************************************
"                      FUNCTIONS
" *****************************************************
" function! Get_ft_words() abort
"   try
"     let l:buf_opt_dict = nvim_buf_get_option(0, 'dictionary')
"   catch /.*/
"     return '/usr/share/dict/words'
"   endtry
"   return l:buf_opt_dict !=# '' ? l:buf_opt_dict : '/usr/share/dict/words'
" endfunction

" *****************************************************
"                       MAPPING
" *****************************************************
nnoremap <silent> <leader>B          :Buffers<cr>
nnoremap <silent> <Leader>L          :Lines<cr>

nnoremap <silent> <leader>@@         :Files<cr>

nnoremap <silent> <leader>ht         :Helptags<cr>
nnoremap <silent> <leader>:          :Cody<cr>
nnoremap <silent> <leader>rg         :RG <c-r><c-w><cr>
nnoremap <silent> <leader>RG         :RG <c-r><c-a><cr>
xnoremap <silent> <leader>rg         y:RG <c-r>"<cr>

inoremap <silent> <expr>   <c-x><c-f> fzf#vim#complete#path('fd -H')
" imap                       <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap     <silent> <expr>   <c-x><c-g> fzf#vim#complete('cat ' . Get_ft_words())
" imap                       <c-x><c-l> <plug>(fzf-complete-line)

" ]]]

