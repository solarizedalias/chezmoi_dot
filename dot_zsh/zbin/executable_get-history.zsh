#!/usr/bin/env zsh

# ==========================================================
# get_history
# Mon Sep 28 10:17:30 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

readonly SOURCE="${${(%):-%N}:a}"
readonly NAME="${SOURCE:t}"
readonly HEAD="${SOURCE:h}"

local    HISTFILE="${HISTFILE:-${ZDOTDIR:-${HOME}}/.zsh_history}"
integer  SAVEHIST="${SAVEHIST:-100000}"
integer  HISTSIZE="${HISTSIZE:-100000}"

[[ -f ${HISTFILE} ]] || exit 1
if fc -p ${HISTFILE} ${HISTSIZE} ${SAVEHIST}; then
  if [[ -n ${history[$1]} ]]; then
    print -r -- ${history[$1]}
  else
    exit 1
  fi
else
  exit 1
fi

