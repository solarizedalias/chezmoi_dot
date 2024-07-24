typeset -a {{_input_:var}}
{{_input_:var}}=( ${(k)functions} )
trap "unset -f -- \"\${(k)functions[@]:|{{_input_:var}}}\" &>/dev/null; unset {{_input_:var}}" EXIT
trap "unset -f -- \"\${(k)functions[@]:|{{_input_:var}}}\" &>/dev/null; unset {{_input_:var}}; return 1" INT

{{_cursor_}}
