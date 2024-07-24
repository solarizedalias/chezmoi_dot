#!/usr/bin/env zsh

# ==========================================================
# brewlet_periodic_copy
# Sat Aug  8 20:42:15 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern
setopt noclobber      noappendcreate

builtin zmodload zsh/system

local INTERVAL="${BREWLET_LOG_CHECK_INTERVAL:-660}"
integer DISPATCHED

readonly THIS="${${(%):-%N}:a}"
readonly NAME="${THIS:t}"

function ${NAME}::usage() {
  local USAGE="
    Usage: ${NAME} [-i|--immediate] [-k|--kill] [-s|--stop] [-h|--help]
      -i, --immediate    Check log files immediately when ${NAME} is invoked.
      -k, --kill         Kill other existing instances and child processes before dispatching new one.
      -s, --stop         Kill existing instances and child processes and exit.
      -h, --help         Print this help.
  "
  USAGE="${(F)${(@)${(f)USAGE%%[[:blank:]]##}#[[:blank:]](#c4)}}"
  print -r -- ${USAGE}
}

function ${NAME:?}::throw() {
  print -r -u2 -- $@
  exit 1
}

local -a args=( $@ )
local -a opts
integer IMMEDIATE=0 KILL=0 STOP=0 HELP=0 UNKNOWN=0
function ${NAME}::parse-opt() {
  set -- ${(@)args}
  zparseopts -a opts -D -E -M -K \
    i -immediate=i \
    k -kill=k \
    s -stop=s \
    h -help=h

  (( $# > 0 )) && (( UNKNOWN++ ))
  for op in ${(@)opts}; do
    case ${op} in
      (-i|--immediate)
        (( IMMEDIATE++ ))
      ;;
      (-k|--kill)
        (( KILL++ ))
      ;;
      (-s|--stop)
        (( STOP++ ))
      ;;
      (-h|--help)
        ((HELP++))
      ;;
    esac
  done
}

function ${NAME:?}::kill-other-instances() {
  local -a childs
  childs=( ${(f)"$(pgrep -f -P ${(@)instances:?} 2>/dev/null || :)"} )
  ps ${(@)childs} ${(@)instances}
  kill ${(@)childs} ${(@)instances:?}
}

function ${NAME:?}::check_instaces() {
  if (( ${#instances} )); then
    (( KILL )) && {
      ${NAME}::kill-other-instances
    } || {
      ${NAME}::throw "${NAME} is already running"
    }
  fi
}

function ${NAME:?}::call-commands() {
  {
    brewlet-check-log-diffs.zsh
    brewlet-log-rename.zsh
  } &!
}

function sleep() {
  : $( read -u 1 -t $(( $1 )) )
}

function ${NAME:?}::periodic-do() {
  print -u2 "${sysparams[pid]:-$$}: sleeping..."
  while sleep "${INTERVAL:?}"; do
    if pgrep -f /usr/local/Homebrew &>/dev/null; then
      notify-all.sh ${(%):-%T} "I think brew is running right now"
      continue
    fi
    ${NAME}::call-commands &>/dev/null ||
      notify-all.sh "${THIS}:${sysparams[pid]:-$$}: Investigate me."
  done
}

function ${NAME:?}::dispatch() {
  ${NAME}::periodic-do &!
  DISPATCHED=$!
  print -r -u2 -- "Dispatched ${DISPATCHED}"
}

# shellspec
${_SOURCED_:+return}

${NAME}::parse-opt

(( HELP )) && {
  ${NAME}::usage
  exit 0
}
(( UNKNOWN )) && {
  print -u2 -r -- "Unknown option(s): $@"
  ${NAME}::usage
  exit 1
}

local -a instances
instances=( ${(f)"$(pgrep -f "zsh ${THIS}")"} )

(( STOP )) && {
  ${NAME}::kill-other-instances
} || {
  ${NAME}::check_instaces
  (( IMMEDIATE )) && ${NAME}::call-commands
  ${NAME:?}::dispatch
}

