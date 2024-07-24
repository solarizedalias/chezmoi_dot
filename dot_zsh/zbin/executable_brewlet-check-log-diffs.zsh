#!/usr/bin/env zsh

# ==========================================================
# brewlet_check_log_diffs
# Sun Jul 19 07:22:39 2020
# AUTHOR: solarizedalias
#
# ==========================================================

# TODO: It seems that formula updates are no longer logged.
#       We should investigate and adapt to the current behavior.

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd  NO_aliases
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern
setopt NO_clobber NO_append_create

local TARGET_DIR="${BREWLET_VAR_DIR:-${HOME}/Library/Logs/Brewlet}"
local -A Targets
Targets=(
  # update  "${TARGET_DIR}/brewlet-upgrade.log"
  upgrade "${TARGET_DIR}/brewlet.log"
)

local LOG_DIR="${BREWLET_LOG_DIR:-${HOME}/.brewlet.log.d}"

local -A Logs
Logs=(
  # make sure to have valid key-value pairs
  # update  "$( builtin print -r -- ${LOG_DIR}/*update*.log(ND-.om[1]) )"
  upgrade "$( builtin print -r -- ${LOG_DIR}/*upgrade*.log(ND-.om[1]) )"
)

local TIME
TIME=${(%):-%D\{%F-%H%M%S\}}
# zc-bg-notify "${0:t}:${TIME}: Checking logs..." &>/dev/null
for key in ${(k)Targets}; do
  if [[ -f ${Targets[${key}]} ]]; then

    integer HASDIFF=0
    local LABEL="${key}"
    if [[ "$(
            IFS= builtin read -r line < ${Targets[${key}]} 2>/dev/null &&
              builtin print -r -- ${line}
          )" == '==> Upgrading '<->' outdated package'(s|)':'* ]]; then
      LABEL="upgrade"
    fi
    if [[ ! -s ${Targets[${key:?}]} ]] ||
      [[ "$(<${Targets[${key}]})" == 'Already up-to-date.' ]]; then
      continue
    fi
    diff ${Targets[${key}]} ${Logs[${LABEL:?}]} &>/dev/null
    HASDIFF=$?
    if (( HASDIFF )); then
      if cp -p ${Targets[${key}]} \
          "${LOG_DIR}"/brewlet-"${LABEL:?}"-"${TIME}".log; then


        (( ${+commands[manpath_compile]} )) && manpath_compile -p
      fi
    fi
  fi
done

