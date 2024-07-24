#!/usr/bin/env zsh

# ==========================================================
# preview_ex
# Thu Oct 29 21:09:25 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

readonly SOURCE="${${(%):-%N}:a}"
readonly NAME="${SOURCE:t}"
readonly HEAD="${SOURCE:h}"

function readlines() {
  local REF="${1:-reply}"
  : ${(PA)REF::=${(f)"$( ${@[2,-1]:-:} )"}}
}

function colorize-pstree() {
  local -a c=(
    ${(%):-%F\{cyan\}} ${(%):-%F\{magenta\}} ${(%):-%F\{yellow\}}
    ${(%):-%F\{red\}}  ${(%):-%F\{blue\}}    ${(%):-%F\{green\}}
    ${(%):-%f}
  )
  local C=${c[1]} M=${c[2]} Y=${c[3]} R=${c[4]} G=${c[5]} B=${c[6]} D=${c[7]}

  local P_GRAPH='([^\!-\~]##[=](#c0,1))' \
        P_PID='(<0->)' P_USER='([[:alnum:]_]##)' P_PROGRAM='(*)'
  local PAT="${P_GRAPH} ${P_PID} ${P_USER} ${P_PROGRAM}"
  local PAT2=' ([-](#c1,2)[^ \-][^ ]##|-[^ \-])((#e)| *)'

  while IFS= read -r line; do
    if [[ ${line} == (#b)${~PAT} ]]; then
      builtin print -r -- \
        $C${match[1]}$D $Y${match[2]}$D $B${match[3]}$D \
        $G${match[4]:gs@(#m)${~PAT2}@$D$Y${MATCH}$D$G@}$D
    else
      builtin print -r -- ${line}
    fi
  done
}

function process() {
  local P="${(M)${1}:#<0->}"
  [[ -n ${P} ]] || return 1
  # local -a cmd=(
  #   ps -p ${P} -o pid,ppid,tty,command -w -w
  # )
  # (( ${+commands[grc]} )) && cmd=( grc --colour=on ${(@)cmd} )
  # eval "command ${(@)cmd}"
  # print -- ' '
  (( ${+commands[pstree]} )) && command pstree -g 3 -p ${P} | colorize-pstree
}

function main() {
  local KIND="$1"
  local -a reply
  if (( ${+functions[${KIND}]} < 1 )); then
    print nokind ${KIND:-empty}
    builtin exit 1
  fi
  shift
  local -a targets=( ${@} )
  print ${(@)targets}
  if (( ${#targets} )); then
    readlines reply ${KIND} ${(@)targets}
    if [[ ${(@)reply} == *[[:graph:]]* ]]; then
      print -rl -- ${(@)reply:-empty}
    else
      print noreply
    fi
  else
    print notarget
  fi
}

# shellspec
${__SOURCED__:+return}

main $@

