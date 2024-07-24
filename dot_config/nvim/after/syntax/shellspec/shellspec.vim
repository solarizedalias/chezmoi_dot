
" WORK IN PROGRESS


" TODO Highlight invalid use of keywords differently
" (e.g., `End` without any block starting keyword,
" `It` not within example group block)


if exists('b:current_syntax') && b:current_syntax !~# 'sh\%($\|\.\)'
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" We want to know which *sh. If not set, assume sh.
let s:shell = exists('b:current_syntax') ? matchstr(b:current_syntax, '\w*sh') : 'sh'

" unlet b:current_syntax

" execute 'runtime! ' . 'syntax/' . s:shell . '.vim'

" We do match cases.
syntax case     match

" TODO Change singletons as Error and create sync groups for valid blocks
syntax match    ShellspecDSLKeyword                     /\<\zs[xf]\=\%(ExampleGroup\|Describe\|Context\)\ze\>/
syntax match    ShellspecDSLKeyword                     /\<\zs\%([xf]\|\)\%(Example\|It\|Specify\)\ze\>/

syntax keyword  ShellspecDSLKeyword                     End

" Should be region, I guess.
syntax region   ShellspecExampleGroupRegion             transparent start='\%(^\|\s\+\)\%(ExampleGroup\|Describe\|Context\)' end='\<End\>'

syntax region   ShellspecExampleRegion                  transparent start='\%(^\|\s\+\)\%(Example\|It\|Specify\)' end='\<End\>'

syntax keyword  ShellspecEvaluationStart                When
      \ nextgroup=ShellspecEvaluationCommand
      \ skipwhite
      \ skipempty
syntax match    ShellspecEvaluationCommand              /\s\<\%(call\|run\)\>\s/ms=s+1,me=e-1
syntax match    ShellspecEvaluationCommand              /\s\<run\s\+\%(command\|script\|source\)\>\s/ms=s+1,me=e-1

syntax keyword  ShellspecExpectationStart               The
      \ nextgroup=ShellspecExpectationModifier,ShellspecExpectationSubject
      \ skipwhite
      \ skipempty

syntax keyword  ShellspecAssert                         Assert

syntax keyword  ShellspecExpectationSubject             stdout output line word stderr error
      \                                                 status path file directory
      \                                                 value function variable
      "\ containedin= TODO
      "\ contained

syntax keyword  ShellspecExpectationModifier            lines length contents result
syntax keyword  ShellspecExpectationModifierDelimiters  of
syntax match    ShellspecExpectationDelimiter           /\s\<\zsshould\ze\>\s/
      \ nextgroup=ShellspecExpectationVerb
syntax match    ShellspecExpectationNegation            /\s\<\zsnot\ze\>\s/

" If there exists more of them, I'd like to know.
syntax match    ShellspecExpectationAdjective           /\s\zs\%(entire\)\ze\s/

syntax keyword  ShellspecNumber                         zeroth first second third fourth fifth sixth seventh eighth ninth tenth
      \                                                 eleventh twelfth thirteenth fourteenth fifteenth
      \                                                 sixteenth seventeenth eighteenth nineteenth twentieth
syntax match    ShellspecNumber                         /\s\<\zs\d*\%(0th\|1st\|2nd\|3rd\|[4-9]th\|1[1-3]th\)\ze\>\s/

"
" MATCHERS
"

syntax match    ShellspecExpectationVerb                /\s\<\zs\%(satisfy\|eq\|equal\|include\)\ze\>\s/
syntax match    ShellspecExpectationVerb                /\s\<\%(start\|end\)\s\+with\>\s/ms=s+1,me=e-1
syntax match    ShellspecExpectationVerb                /\s\<be\ze\s\+\%(exist\|file\|directory\|empty\|symlink\|pipe\|socket\|readable\|writable\|executable\|block_device\|character_device\|success\|failure\|valid\|defined\|undefined\|present\|blank\)\>/ms=s+1
syntax match    ShellspecExpectationVerb                /\s\<has\ze\s\+\%(setgid\|setuid\)\>\s/ms=s+1,me=e-1
syntax match    ShellspecExpectationVerb                /\s\<match\s\+pattern\>\s/ms=s+1,me=e-1

syntax keyword  ShellspecExpectationStatMatcher         exist file directory empty symlink pipe socket readable writable
      \                                                 executable block_device character_device setgid setuid

syntax keyword  ShellspecExpectationStatusMatcher       success failure
syntax match    ShellspecExpectationValidMatcher        /\s\<valid\s\+\%(number\|funcname\)\>\s/ms=s+1,me=e-1
syntax keyword  ShellspecExpectationVariableMatcher     defined undefined present blank

syntax keyword  ShellspecHelper                         Pending
syntax keyword  ShellspecHelper                         Todo


" XXX Since I couldn't figure out how to evade `shIf` from sh.vim,
" which unconditionally expects `fi` and take any other things as belongings to
" `shIfList` block, I had to get rid of that group and make a new shIf which ignores any `if` right after `Skip`.
if s:shell ==# 'sh'
  syntax clear  shIf
  syntax region shIf transparent matchgroup=shConditional start="\%(Skip\s\+\)\@<!\<if\_s" matchgroup=shConditional skip=+-fi\>+ end="\<;\_s*then\>" end="\<fi\>"	contains=@shIfList
endif

syntax match    ShellspecSkipCondition                  /\%(#.*\)\@<!\<\zsSkip\%(\s\+if\|\)\>/
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList,shIf

" syntax region   ShellspecSkipConditionRegion            start='^\s*\<Skip\s+if\>\s\+\zs' end='$'
"       \ contains=String,Identifier

" syntax sync match ShellspecSkipConditionSync grouphere  ShellspecSkipConditionRegion 'Skip\s\+if'
" syntax sync match ShellspecSkipConditionSync groupthere ShellspecSkipConditionRegion '$'


syntax match    ShellspecData                           /\<\zsData\ze\>/

" syntax region   ShellspecDataRegion                     transparent start='^\s*\<\zsData\%(\s*$\|:raw\|:expand\|\s\+[A-Za-z][a-z]*$\)\ze\>' end='\s*\<\zsEnd\ze\>\s*$'
"       \ contains=ShellspecDataHereDoc,Comment,Function,Keyword,Title,Type,Error

" TODO Comments inside #| block
" TODO contained
syntax region   ShellspecDataHereDoc                    oneline start='\%(^\|^\s\+\)#|' end='\%(#\|$\)'
      \ containedin=Function,Comment,shFunctionOne,@shCommandSubList,@shIfList
      \ contains=shDeref,shDerefSimple
      " \ containedin=ShellspecDataRegion contained
syntax region   ShellspecDataHereDoc                    start='^\s*#|' end='\%(#[^|]\|^\%(\s*#|\)\@!\)'
      \ containedin=Function,Comment,shFunctionOne,@shCommandSubList,@shIfList
      \ contains=shDeref,shDerefSimple
      " \ containedin=ShellspecDataRegion contained

" syntax region   ShellspecParametersRegion               transparent start='^\<Parameters\%(\|:block\|:value\|:matrix\|:dynamic\)\>' end='\<End\>'

" FIXME No idea how this fails
syntax match    ShellspecColonModifier                  /:\%(raw\|expand\|block\|value\|matrix\|dynamic\)/ms=s+1
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList

" @shIfList
syntax match    ShellspecDirective                      '%\s\+\h\w*'
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList
syntax match    ShellspecDirective                      '%[-=]'
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList
syntax match    ShellspecDirective                      '%const\ze\s*'
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList

" FIXME didn't highlight %logger in hook() { %logger "$1 $2 ${SHELLSPEC_EXAMPLE_ID}"; }
syntax match    ShellspecDirective                      /%\%(text\|putsn\|puts\|logger\)/
      \ containedin=Function,shFunctionOne,@shCommandSubList,@shIfList

syntax keyword  ShellspecHooks                          Before After BeforeAll AfterAll BeforeCall AfterCall
      \                                                 BeforeRun AfterRun
syntax keyword  ShellspecMisc                           Include Path File Dir Intercept Set Dump

syntax keyword  ShellspecSpecialVariables               SHELLSPEC_ROOT SHELLSPEC_LIB SHELLSPEC_LIBEXEC
      \                                                 SHELLSPEC_TMPDIR SHELLSPEC_TMPBASE SHELLSPEC_WORKDIR
      \                                                 SHELLSPEC_SPECDIR SHELLSPEC_LOAD_PATH SHELLSPEC_UNIXTIME
      \                                                 SHELLSPEC_SPECNO SHELLSPEC_GROUP_ID SHELLSPEC_EXAMPLE_ID
      \                                                 SHELLSPEC_EXAMPLE_NO


highlight default link ShellspecDSLKeyword                    Title

highlight default link ShellspecExampleGroupRegion            ShellspecDSLBlock
highlight default link ShellspecExampleRegion                 ShellspecDSLBlock

highlight default link ShellspecEvaluationStart               Title
highlight default link ShellspecEvaluationCommand             Keyword
highlight default link ShellspecExpectationStart              Title
highlight default link ShellspecAssert                        Title
highlight default link ShellspecExpectationDelimiter          Title
highlight default link ShellspecExpectationNegation           Boolean
highlight default link ShellspecExpectationSubject            Keyword
highlight default link ShellspecExpectationAdjective          Type
highlight default link ShellspecNumber                        Number
highlight default link ShellspecExpectationModifier           Keyword
highlight default link ShellspecExpectationModifierDelimiters Title

highlight default link ShellspecExpectationVerb               Keyword
highlight default link ShellspecExpectationStatMatcher        ShellspecMatcher
highlight default link ShellspecExpectationStatusMatcher      ShellspecMatcher
highlight default link ShellspecExpectationValidMatcher       ShellspecMatcher
highlight default link ShellspecExpectationVariableMatcher    ShellspecMatcher

highlight default link ShellspecMatcher                       Type
highlight default link ShellspecHelper                        Title
highlight default link ShellspecSkipCondition                 Title
highlight default link ShellspecData                          Include
highlight default link ShellspecDataRegion                    None
highlight default link ShellspecDataHereDoc                   String
highlight default link ShellspecParametersRegion              PreProc
highlight default link ShellspecColonModifier                 Define
highlight default link ShellspecDirective                     Constant
highlight default link ShellspecHooks                         Include
highlight default link ShellspecMisc                          Include
highlight default link ShellspecSpecialVariables              Constant

" let b:current_syntax = 'shellspec'

let &cpoptions = s:cpo_save
unlet s:cpo_save

