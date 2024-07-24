# vim: set ft=zsh:

# ==========================================================
# stop_brewlet_and_watcher
# Thu Jul  9 18:35:28 2020
# AUTHOR: solarizedalias
#
# ==========================================================

function throw() {
  print -l $* >&2
  exit 1
}

local -a watch_procs
local BREWLET_PROC

# returns 1 if none of the targets is found, 0 otherwise.
# Set watch_procs and BREWLET_PROC as side effects.
# Should be called at least once prior to other functions which kills watcher processes.
function find_procs() {
  integer RET=0
  watch_procs=( $(pgrep -f '(zsh|fswatch).*brewlet.*') ) || RET=1
  BREWLET_PROC="$(pgrep -f 'Brewlet\.app')" || RET=1
  return ${RET}
}

function check_remainder() {
  find_procs || return 0
  return 1
}

function kill_watchers() {
  kill ${(@)watch_procs}
}

function quit_or_kill_Brewlet() {
  # Try the gracefull way first.
  osascript -e 'quit app "Brewlet"'
  sleep 1
  # Go aggresive if necessary.
  if pgrep -f 'Brewlet\.app' >/dev/null 2>&1; then
    pkill 'Brewlet'
  fi
}

function main() {
  find_procs || \
    throw "Cannot find process(es): ${${${watch_procs[*]}:+:}:-watch_procs}${${BREWLET_PROC:+:}:-BREWLET_PROC}"

  kill_watchers && quit_or_kill_Brewlet
  {
    check_remainder && print -l "Good." && exit 0
  } || {
    print -l "Bad."
    exit 1
  }
}

