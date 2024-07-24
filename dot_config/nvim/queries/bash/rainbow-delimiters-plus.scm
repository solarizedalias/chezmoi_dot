(command_substitution
  "$(" @opening
  ")"  @closing) @container

(expansion
  "${" @opening
  (["-" ":-" "+" ":+"] @intermediate)?
  "}" @closing) @container

;;; The double-bracket variant is a bashism
(test_command
  ["[[" "["] @opening
  ["]]" "]"] @closing) @container

(subshell
 "(" @opening
 ")" @closing) @container

(process_substitution
  "<(" @opening
  ")"  @closing) @container

(arithmetic_expansion
  "((" @opening
  "))" @closing) @container

(arithmetic_expansion
  "$((" @opening
  "))" @closing) @container

(subscript
  "[" @opening
  "]" @closing) @container

(array
  "(" @opening
  ")" @closing) @container

(compound_statement
  "{" @opening
  "}" @closing) @container

(function_definition
  "(" @opening
  ")" @closing
  ) @container

