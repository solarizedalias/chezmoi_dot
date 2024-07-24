#!/usr/bin/env zsh

# ==========================================================
# zsh_abbr_force_tmp
# Mon Jan  4 22:22:29 2021
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent NO_short_loops NO_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern
setopt NO_clobber     NO_append_create

readonly SOURCE="${${(%):-%N}:a}"
readonly NAME="${SOURCE:t}"
readonly HEAD="${SOURCE:h}"

integer INTERVAL
INTERVAL=${${(M)ZSH_ABBR_FORCE_TMP_INTERVAL:#[0-9]##(|.[0-9]##)}:-3}

function force-create() {
  (
    exec zsh -li -c '
      [[ -v ZINIT ]] && . "${ZINIT[PLUGINS_DIR]}"/olets---zsh-abbr/zsh-abbr.zsh
      exit 0
    '
  )
}

function main-loop() {
  while : $(builtin read -t $(( INTERVAL )) -u 1 ); do
    if builtin cd -q "${TMPDIR:?}/zsh-abbr" 2>/dev/null; then
      :
    else
      force-create
      continue
    fi
    if [[ -r global-user-abbreviations && -r regular-user-abbreviations ]]; then
      :
    else
      force-create
      continue
    fi
  done
}

local -a opts
zparseopts -a opts -D -K -M -E \
  h -help=h \
  v -v -version=v \
  k -kill=k

integer O_HELP O_VERSION O_KILL
: ${O_HELP::=${opts[(I)(-h|--help)]}} \
  ${O_VERSION::=${opts[(I)(-v|--version)]}} \
  ${O_KILL::=${opts[(I)(-k|--kill)]}}

if (( O_HELP )); then
  : TODO
  exit 0
elif (( O_VERSION )); then
  : TODO
  exit 0
elif (( O_KILL )); then
  local -a pids
  pids=( ${(f)"$(command pgrep -P 1 -f "${${(%):-%N}:a}" )"} )
  if (( $? == 0 )); then
    kill "${pids[1]}"
    integer RET=$?
    if (( RET == 0 )); then
      print -r -- "${0:t} Killed ${pids[1]}"
      exit 0
    else
      print -u2 -r -- "${0:t} Failed to kill ${pids[1]}"
    fi
  else
    print -r -u2 -- "${0:t}: Cannot find the instance"
    exit 1
  fi
else
  main-loop &!
  print -r -- "${0:t}: Dispatched $!"
  exit 0
fi

