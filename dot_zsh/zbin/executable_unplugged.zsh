#!/usr/bin/env zsh

# ==========================================================
# unplugged
# Fri Aug 21 10:40:56 2020
# AUTHOR: solarizedalias
# Version: 0.0.1
# ==========================================================

# zmodload zsh/system
# exec &>> "${TMPPREFIX:-/tmp/zsh}/${0:t}-${sysparams[pid]:-$$}.log"
# mkdir -p "${TMPPREFIX:-/tmp/zsh}"
# print -rl -- \
#   "ZSH_PATCHLEVEL: ${ZSH_PATCHLEVEL}" \
#   "ZSH_ARGZERO: ${ZSH_ARGZERO}" \
#   "ZSH_NAME: ${ZSH_NAME}"

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

readonly SOURCE="${${(%):-%N}:a}"
readonly NAME="${SOURCE:t}"
readonly HEAD="${SOURCE:h}"
readonly VERSION='0.0.1'

readonly PID=$$

typeset -A Flags=( [HELP]=0 [VERSION]=0 [KILL]=0 )
local -a opts
zparseopts -a opts -D -K -M -E h -help=h v -version=v k -kill=k
: ${Flags[KILL]::=${opts[(I)(-k|--kill)]}} \
  ${Flags[HELP]::=${opts[(I)(-h|--help)]}} \
  ${Flags[VERSION]::=${opts[(I)(-v|--version)]}}

function kill-other-instances() {
  # TODO Creating a "lock" file containing the PID at the beginning of normal
  #      invocation and looking for that file would be more reliable.

  local TARGET_PID
  local -a pids

  pids=( $( /usr/bin/pgrep -f "zsh ${SOURCE}" ) )
  TARGET_PID=${(@R)pids:#${PID}}
  if [[ ${TARGET_PID} != <1-> ]]; then
    print -lr -- "No instance found"
    exit 1
  fi
  kill ${TARGET_PID} && print -- "${NAME}: Successfully killed ${TARGET_PID}."
}

function sleep() {
  : $( read -u 1 -t ${1:-3} )
}

function sleep-aslongas-plugged() {
  integer INTERVAL="${1:-1}"
  while sleep ${INTERVAL} &&
    [[ ${(Q)${(f)"$( /usr/bin/pmset -g ps )"}[1][(w)-2,-1]} == 'AC Power' ]]; do
      :
  done
  return 1
}

function plug-it-now-or-i-will-get-you-sleep() {
  integer DUE="${1:-3}"
  float INTERVAL="${2:-0.5}"

  repeat $(( DUE / INTERVAL )); do
    if sleep ${INTERVAL} &&
      [[ ${(Q)${(f)"$( pmset -g ps )"}[1][(w)-2,-1]} == 'AC Power' ]]; then
        return 0
    fi
  done
  return 1
}

function invoke-notifiers() {
  local -a cmds=( ${(@P)1} )
  for c in ${(@)cmds}; do
    [[ ${+commands[${c}]} ]] && eval ${c} "!!!! AC UNPLUGGED !!!!"
  done
}

function main-loop() {
  local -a notifiers=(
    ${(@)^path}/(zc-bg-notify|notify)(ND-*)
  )
  while true; do
    sleep-aslongas-plugged ||
      plug-it-now-or-i-will-get-you-sleep ||
      /usr/bin/pmset sleepnow &>/dev/null
      # /usr/bin/osascript -e 'tell application "Finder" to sleep'
    # invoke-notifiers notifiers
  done
}

# shellspec
${__SOURCED__:+return}


if (( ${Flags[KILL]} )); then
  kill-other-instances
  exit $?
fi

function main(){
  main-loop &
}

main
print -- ${NAME}: Dispatched $!
jobs
disown

