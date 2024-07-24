
" if exists('b:did_ftplugin')
"   finish
" endif

let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let s:indented = '^\(\s*\)'

let b:match_words .=
      \   ',' . s:indented . '\<\zs[xf]\=\%(ExampleGroup\|Describe\|Context\)\>:^\1\zsEnd\>'
      \ . ',' . s:indented . '\<\zs[xf]\=\%(Example\|It\|Specify\)\>:^\1\zsEnd\>'
      \ . ',' . s:indented . '\<\zsData\>:^\1\zsEnd\>'

let b:match_skip = 's:comment\|string\|heredoc\|subst'

let &cpoptions = s:cpo_save
unlet s:cpo_save

