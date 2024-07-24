scriptencoding utf-8

let g:lightline = {
  \   'enable'   : {
  \     'statusline' : 1,
  \     'tabline'    : 0,
  \   },
  \   'colorscheme'  : 'transparentBG',
  \   'separator'    : { 'left' : '', 'right' : '' },
  \   'subseparator' : { 'left' : '', 'right' : '' },
  \   'mode_map'     : {
  \     'n'      : 'N☛',
  \     'i'      : 'I',
  \     'R'      : 'R𝌡',
  \     'v'      : 'V◬',
  \     'V'      : 'V☰',
  \     "\<C-v>" : 'V▞',
  \     'c'      : 'C␦',
  \     's'      : 'S⋰',
  \     'S'      : 'S☰',
  \     "\<C-s>" : 'S▞',
  \     't'      : '>_',
  \   },
  \   'active': {
  \     'left' :   [
  \                  [ 'mode', 'paste', 'currentcomp' ],
  \                  [ 'git' ],
  \                  [ 'readonly', 'pwd', 'filename', 'modified', 'codelf', 'ts_or_syn_atr' ],
  \                ],
  \     'right':   [
  \                   [ 'percent' ],
  \                   [ 'bufnr_winnr', 'lineinfo'],
  \                   [ 'filetype'],
  \                   [ 'codeium' ],
  \                   [ 'nvim_lsp_active' ],
  \                   ['nvim_diagnostic_done',  'nvim_diagnostic_not_yet',
  \                    'nvim_diagnostic_error', 'nvim_diagnostic_warn',
  \                    'nvim_diagnostic_info',  'nvim_diagnostic_hint'],
  \                   ['linter_checking', 'linter_errors', 'linters_warnings',
  \                    'linter_infos', 'linter_ok'],
  \                ],
  \   },
  \   'inactive': {
  \     'left':  [ [ 'filename' ] ],
  \     'right': [ [ 'percent' ], ['bufnr_winnr', 'lineinfo' ] ],
  \   },
  \   'tabline': {
  \     'left' :   [ [ 'mode' ], [ 'tabs' ] ],
  \     'right':   [ [ 'close' ] ],
  \   },
  \   'tab': {
  \     'active':   [ 'tabnum', 'filename', 'modified' ],
  \     'inactive': [ 'tabnum', 'filename', 'modified' ],
  \   },
  \   'component_function' : {
  \     'pwd'            : 'LightlinePWD',
  \     'filename'       : 'LightlineFilename',
  \     'bufnr_winnr'    : 'LightlineBufnrWinnr',
  \     'git'            : 'LightlineGit',
  \     'ts_or_syn_atr'  : 'LightlineTSOrSynAtr',
  \     'codeium'        : 'codeium#GetStatusString',
  \     'nvim_lsp_active': 'LightlineNvimLspActive',
  \   },
  \   'component': {
  \     'percent': '%3p %%',
  \   },
  \   'component_expand': {
  \     'nvim_diagnostic_error':   'LightlineNvimDiagnosticError',
  \     'nvim_diagnostic_warn' :   'LightlineNvimDiagnosticWarn',
  \     'nvim_diagnostic_info' :   'LightlineNvimDiagnosticInfo',
  \     'nvim_diagnostic_hint' :   'LightlineNvimDiagnosticHint',
  \     'nvim_diagnostic_done' :   'LightlineNvimDiagnosticDone',
  \     'nvim_diagnostic_not_yet': 'LightlineNvimDiagnosticNotYet',
  \   },
  \   'component_type': {
  \     'nvim_diagnostic_error':   'error',
  \     'nvim_diagnostic_warn':    'warning',
  \     'nvim_diagnostic_info':    'raw',
  \     'nvim_diagnostic_done':    'raw',
  \     'nvim_diagnostic_not_yet': 'raw',
  \   },
  \}

function! LightlineNvimDiagnosticError() abort
  if has('nvim')
    return luaeval('require("custom/lightline")' .
          \ '.diagnostic_component(_A, vim.diagnostic.severity.ERROR)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimDiagnosticWarn() abort
  if has('nvim')
    return luaeval('require("custom/lightline")' .
          \ '.diagnostic_component(_A, vim.diagnostic.severity.WARN)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimDiagnosticInfo() abort
  if has('nvim')
    return luaeval('require("custom/lightline")' .
          \ '.diagnostic_component(_A, vim.diagnostic.severity.INFO)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimDiagnosticHint() abort
  if has('nvim')
    return luaeval('require("custom/lightline")' .
          \ '.diagnostic_component(_A, vim.diagnostic.severity.HINT)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimDiagnosticDone() abort
  if has('nvim')
    return luaeval('require("custom/lightline").diagnostic_component(_A, 0)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimDiagnosticNotYet() abort
  if has('nvim')
    return luaeval('require("custom/lightline").diagnostic_component(_A, -1)',
          \ nvim_get_current_buf())
  endif
  return ''
endfunction

function! LightlineNvimLspActive() abort
  return has('nvim') &&
        \ luaeval('#vim.tbl_keys(vim.lsp.get_clients({ bufnr = 0 }))') > 0 ? '[lsp]' : ''
endfunction

" Depends on https://github.com/rktjmp/git-info.vim
" use jobstart() so it's neovim only
function! s:LightlineGitBranchName()
  if len(git_info#branch_name())
    return ' ' . git_info#branch_name()
  endif
  return ''
endfunction

" Depends on https://github.com/rktjmp/git-info.vim
" use jobstart() so it's neovim only
function! s:LightlineGitDirty()
  let l:changes = git_info#changes()
  if l:changes.changed > 0 || l:changes.untracked > 0
    return '*'
  endif
  return ''
endfunction

" Depends on https://github.com/rktjmp/git-info.vim
" use jobstart() so it's neovim only
function! s:LightlineGitStatus()
  let l:s = {
        \ 'changed': '∆',
        \ 'insertions': '+',
        \ 'deletions': '-',
        \ 'untracked': '?'
        \ }
  " return the as_string representation, which will be '' if no changes
  " are present, which will hide the subsection
  let l:c = git_info#changes()
  let l:ret = ''
  let l:ret .= l:c['changed']    != 0 ? ' ' . l:s['changed']    . l:c['changed']    : ''
  let l:ret .= l:c['insertions'] != 0 ? ' ' . l:s['insertions'] . l:c['insertions'] : ''
  let l:ret .= l:c['deletions']  != 0 ? ' ' . l:s['deletions']  . l:c['deletions']  : ''
  let l:ret .= l:c['untracked']  != 0 ? ' ' . l:s['untracked']  . l:c['untracked']  : ''
  return l:ret
endfunction

" Wrapper
function! LightlineGit(...) abort
  if has('nvim')
    let l:b = s:LightlineGitBranchName()
    let l:d = s:LightlineGitDirty()
    let l:s = s:LightlineGitStatus()
    return '' . l:b . l:d . l:s
  else
    return ''
  endif
endfunction

function! s:treesitter_node() abort
  if exists('*nvim_treesitter#statusline')
    return nvim_treesitter#statusline({'indicator_size': 100})
  endif
  return ''
endfunction

function! s:syntax_attr() abort

  let l:synid = ''

  let l:id1  = synID(line('.'), col('.'), 1)
  let l:tid1 = synIDtrans(l:id1)

  if synIDattr(l:id1, 'name') !=# ''
    let l:synid = synIDattr(l:id1, 'name')
    if (l:tid1 != l:id1)
      let l:synid = l:synid . '->' . synIDattr(l:tid1, 'name')
    endif
    let l:id0 = synID(line('.'), col('.'), 0)
    if synIDattr(l:id1, 'name') != synIDattr(l:id0, 'name')
      let l:synid = l:synid .  ' (' . synIDattr(l:id0, 'name')
      let l:tid0 = synIDtrans(l:id0)
      if (l:tid0 != l:id0)
        let l:synid = l:synid . '->' . synIDattr(l:tid0, 'name')
      endif
      let l:synid = l:synid . ')'
    endif
  endif

  if len(l:synid) > 20
    let l:synid = l:synid[:- 20 + 1]
  endif

  return l:synid

endfunction

function! LightlineTSOrSynAtr() abort
  let l:ts = s:treesitter_node()
  if empty(l:ts)
    return s:syntax_attr()
  endif
  return l:ts
endfunction

if !has('nvim')
  let g:lightline#ale#indicator_checking = "\uf110 "
  let g:lightline#ale#indicator_infos    = "\uf129 "
  let g:lightline#ale#indicator_warnings = "\uf071 "
  let g:lightline#ale#indicator_errors   = "\uf05e "
  let g:lightline#ale#indicator_ok       = "\uf00c "

  let g:lightline.component_expand = {
        \  'linter_checking' : 'lightline#ale#checking',
        \  'linter_infos'    : 'lightline#ale#infos',
        \  'linter_warnings' : 'lightline#ale#warnings',
        \  'linter_errors'   : 'lightline#ale#errors',
        \  'linter_ok'       : 'lightline#ale#ok',
        \ }
  let g:lightline.component_type = {
        \  'linter_checking' : 'right',
        \  'linter_infos'    : 'right',
        \  'linter_warnings' : 'warning',
        \  'linter_errors'   : 'error',
        \  'linter_ok'       : 'right',
        \ }
endif

function! LightlineFilename()
  let l:name = expand('%:t')
  return empty(l:name) ? '[No Name]' : l:name
endfunction

function! LightlinePWD()
  return pathshorten(getcwd())
endfunction

function! LightlineBufnrWinnr() abort
  return bufnr() . ' ' . win_getid()
endfunction

" XXX compile these
let s:none              = [  'NONE'   , 'NONE' ]

let s:base0             = [ '#808070' ,  244   ]
let s:base1             = [ '#949484' ,  246   ]
let s:base2             = [ '#a8a897' ,  248   ]
let s:base3             = [ '#e8e8d3' ,  253   ]
let s:base00            = [ '#666656' ,  242   ]
let s:base01            = [ '#4e4e43' ,  239   ]
let s:base02            = [ '#30302c' ,  236   ]
let s:base03            = [ '#151513' ,  233   ]
let s:yellow            = [ '#e6e633' ,  221   ]
let s:orange            = [ '#f6bb60' ,  208   ]
let s:red               = [ '#f04128' ,  197   ]
let s:magenta           = [ '#f628ba' ,  213   ]
let s:magentadim        = [ '#f09af9' ,  013   ]
let s:blue              = [ '#0663f9' ,  063   ]
let s:bluedim           = [ '#8faaf9' ,  068   ]
let s:cyan              = [ '#2fdfdc' ,  087   ]
let s:green             = [ '#28fc32' ,  119   ]
let s:greendim          = [ '#61bc94' ,  071   ]

let s:p                 = {
      \  'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'command': {}, 'tabline': {}
      \ }

let s:p.normal.left     = [ [ s:base03, s:blue   , 'bold' ], [ s:base3,  s:bluedim,    'bold' ], [ s:base2  , s:none ] ]
let s:p.command.left    = [ [ s:base03, s:yellow , 'bold' ], [ s:base3,  s:orange,     'bold' ], [ s:base2  , s:none ] ]
let s:p.insert.left     = [ [ s:base02, s:green  , 'bold' ], [ s:base3,  s:greendim,   'bold' ], [ s:base2  , s:none ] ]
let s:p.visual.left     = [ [ s:base02, s:magenta, 'bold' ], [ s:base3,  s:magentadim, 'bold' ], [ s:base2  , s:none ] ]
let s:p.replace.left    = [ [ s:base02, s:red    , 'bold' ], [ s:base3,  s:orange,     'bold' ], [ s:base2  , s:none ] ]
let s:p.inactive.left   = [ [ s:base0 , s:none            ], [ s:base3,  s:base0,      'bold' ], [ s:base00 , s:none ] ]

let s:p.normal.right    = [ [ s:base03, s:blue   , 'bold' ], [ s:base3, s:none ], [ s:base3, s:none ], ]
let s:p.insert.right    = [ [ s:base03, s:green  , 'bold' ], [ s:base3, s:none ], [ s:base3, s:none ], ]
let s:p.visual.right    = [ [ s:base03, s:magenta, 'bold' ], [ s:base3, s:none ], [ s:base3, s:none ], ]
let s:p.command.right   = [ [ s:base03, s:yellow , 'bold' ], [ s:base3, s:none ], [ s:base3, s:none ], ]
let s:p.replace.right   = [ [ s:base03, s:red    , 'bold' ], [ s:base3, s:none ], [ s:base3, s:none ], ]
let s:p.inactive.right  = [ [ s:base02, s:none            ], [ s:base0, s:none ], [ s:base3, s:none ], ]

let s:p.inactive.middle = [ [ s:base00 , s:none ] ]

let s:p.normal.error    = [ [ s:red    , s:none ] ]
let s:p.normal.warning  = [ [ s:yellow , s:none ] ]

let s:p.normal.middle   = [ [ s:base0  , s:none ] ]

let s:p.tabline.left    = [ [ s:base3  , s:none ] , [ s:base3  , s:none ] ]
let s:p.tabline.tabsel  = [ [ s:base3  , s:none ] ]
let s:p.tabline.right   = copy(s:p.normal.right)

let g:lightline#colorscheme#transparentBG#palette = lightline#colorscheme#flatten(s:p)

call lightline#enable()
call lightline#update()

" vim:foldmethod=indent:
