#!/usr/bin/env zsh

# ==========================================================
# brewlet_log_viewer
# Fri Jul 24 11:28:47 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

function throw() {
  print -l $@ >&2
  exit 1
}

local LOGDIR="${BREWLET_LOG_DIR:-${HOME}/.brewlet.log.d}"
pushd "${LOGDIR}" ||
  throw 'Where do you store the logs?' 'Give me the location as ${BREWLET_LOG_DIR}'

if (( ${+commands[rg]} && ${+commands[more]} && ${+commands[bat]} )); then
  :
else
  throw 'You miss some commands' 'Do you have all of them?' 'rg (ripgrep), bat, more'
fi

function convert-date() {
  local DATE
  local -a match mbegin mend
  local MATCH MBEGIN MEND
  while read -r line; do
    print -r -- \
      ${line/#(#b)([0-9](#c4))-([0-9](#c2))-([0-9](#c2))-([0-9](#c6)).log/"$(
        command date -d \
          "${match[1]}-${match[2]}-${match[3]} ${${match[4]//(#m)([0-9][0-9])/${MATCH}:}%:}" \
          '+%Y %m %d %H:%M:%S'
      )"}
  done
}

function ShowUpdate() {
  # Based on 3000 << ARG_MAX / 65 =~ 4032
  local -a updates=( *-update-*.log(NOm[1,3000]) )
  (( ${#updates} )) || return 1
  rg -v '(Already up-to-date|No changes to formulae|Updated Homebrew)' ${(@on)updates} |
    cut -d'-' -f3- |
    convert-date |
    rg --pcre2 --passthru --case-sensitive --color=always \
      '(?<=\d{4} \d{2} \d{2} [0-2]\d:[0-5]\d:[0-5]\d:)[a-z0-9].*' |
    more -R -e
}

function ShowUpgrade() {
  local -a upgrades=( *-upgrade-*.log(NOn[1,3000]) )
  (( ${#upgrades} )) || return 1
  BAT_PAGER='more -R -e --chop-long-lines' bat --style=header,grid ${(@)upgrades}
}

case ${1} in
  (*d*)
    ShowUpdate
  ;;
  (*g*)
    ShowUpgrade
  ;;
esac

popd && exit 0

