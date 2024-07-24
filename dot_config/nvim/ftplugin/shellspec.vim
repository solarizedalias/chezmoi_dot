
if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let b:match_words = ',\<\%(ExampleGroup\|Describe\|Context\)\>:\<End\>'
      \ . ',\<\%([xf]\|\)\%(Example\|It\|Specify\)\>:\<End\>'
      \ . ',\<Data\>:\<End\>'
let b:match_skip = 's:comment\|string\|heredoc\|subst'

let &cpoptions = s:cpo_save
unlet s:cpo_save

