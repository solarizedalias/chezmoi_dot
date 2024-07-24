
let s:cpo_save = &cpo
set cpo&vim

syntax clear pegComment
syntax match pegComment /\%(^\|[^\#]\)\zs\#.*$/ contains=pegTodo

let &cpoptions = s:cpo_save

