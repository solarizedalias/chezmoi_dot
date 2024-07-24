#!/usr/bin/env zsh

local DEBUG=0

local -a opts
zparseopts -a opts -D -debug d
(( ${#opts} )) && DEBUG=1


# https://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
# Then ${0:h} to get plugin’s directory

readonly THISFILE="${0:t}"

(( DEBUG )) && echo "${THISFILE}" >&2

readonly LOGFILE_DIR="${BREWLET_LOGFILE_DIR:=${HOME}/.brewlet.log.d}"
readonly LOCKFILE="${BREWLET_LOGFILE_DIR:-${HOME}}/lock"

local UPDATE_LOG UPGRADE_LOG
UPDATE_LOG="$(fd 'brewlet-upgrade\.log' /var/folders -tf -HI --full-path | head -n1)"
UPGRADE_LOG="$(fd 'brewlet-package-upgrade\.log' /var/folders -tf -HI --full-path | head -n1)"

UPDATE_LOG="${UPDATE_LOG:-/var/folders/1f/pltvm3g54157_1jfq2vl4c8m0000gn/T/brewlet-upgrade.log}"
UPGRADE_LOG="${UPGRADE_LOG:-/var/folders/1f/pltvm3g54157_1jfq2vl4c8m0000gn/T/brewlet-package-upgrade.log}"

function check_other_instances() {
  if [[ -f ${LOCKFILE} ]] && ps p ${(f)"$(< "${LOCKFILE}")"} >/dev/null 2>&1; then
    echo "Another Instance is already running" >&2
    {
      pgrep -lf ".*fswatch.*${UPDATE_LOG}"  >&2
      pgrep -lf ".*fswatch.*${UPGRADE_LOG}" >&2
    } || {
        echo "Cannot find the fswatch process(es)."
        echo "Try killing the process(es) manually."
    } >&2
    return 1
  fi

  return 0
}

function wait_brew_starts() {
  until pgrep -f -P $(pgrep Brewlet) 'ruby' 'brew' 2>/dev/null; do
    :
  done
  return 0
}

function wait_brew_ends() {
  # local PID
  # PID="$(pgrep -f -P $(pgrep Brewlet) ruby)"
  # wait ${PID}

  wait $1
  # while ps p $1 >/dev/null 2>&1 ; do
  #   :
  # done
  return 0
}


check_other_instances || exit 1

#
# main
#
[[ -d "${LOGFILE_DIR}" ]] || mkdir -p "${LOGFILE_DIR}"

# TODO function dispatcher()

local -a dispatched

(
  fswatch "${UPDATE_LOG}" | \
    while read -r line; do
      ((DEBUG)) && echo "line ${line} UPDATE_LOG ${UPDATE_LOG}" >&2
      local BREW_PID
      BREW_PID="$(wait_brew_starts)" && \
        wait_brew_ends ${BREW_PID} && \
        sleep 60
        cat "${UPDATE_LOG}" >> "${LOGFILE_DIR}/brewlet-update-$(date "+%F-%H%M%S").log"
    done
) >/dev/null 2>&1 &

dispatched+=($!)

(
  fswatch "${UPGRADE_LOG}" | \
    while read -r line; do
      ((DEBUG)) && echo "line ${line} UPGRADE_LOG ${UPGRADE_LOG}" >&2
      local BREW_PID
      BREW_PID="$(wait_brew_starts)" && \
        wait_brew_ends ${BREW_PID} && \
        sleep 120
        cat "${UPGRADE_LOG}" >> "${LOGFILE_DIR}/brewlet-upgrade-$(date "+%F-%H%M%S").log"
    done
) >/dev/null 2>&1 &

dispatched+=($!)

local MATCH
local THISFILE_ESCAPED="${THISFILE:gs@(#m)(.)@\\${MATCH}}"

local -a instances
instances=( $(pgrep -f "zsh +.*${THISFILE_ESCAPED}") )


print -ln "${(@)instances}" >| "${LOCKFILE}"

disown

local -a actual_fswatch_instances
actual_fswatch_instances=( $(pgrep -f 'fswatch.+brewlet.+log') )

if (( ${#actual_fswatch_instances} == ${#dispatched} )); then
  echo "Dispatched ${#dispatched} processes."
  print -l ${(@)dispatched}
  (( DEBUG )) && {
    echo "Found ${(@)actual_fswatch_instances}"
  } >&2
  exit 0
else
  {
    echo "Expected ${#dispatched} process(es) but found ${#actual_fswatch_instances}."
    echo "Actual fswatch process(es) is (are)..."
    print -l ${(@)actual_fswatch_instances}
  } >&2
  exit 1
fi

