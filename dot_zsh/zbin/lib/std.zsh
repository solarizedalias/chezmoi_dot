
# vim: set ft=zsh:

# ==========================================================
# std
# Sun Aug 16 14:40:06 2020
# AUTHOR: solarizedalias
#
# ==========================================================

local THISMODULE="${${(%):-%0x}:a}"
local MODULENAME="${THISMODULE:t}"
local MODULEDIR="${THISMODULE:h}"

function raise() {
  print -- $@ >&2
  exit 1
}

function warn() {
  print -- $@ >&2
}

{
  (( ${+parameters[Modules]} )) && [[ ${(t)Modules} == *association* ]]
} || {
  typeset -Ag Modules
}

Modules[${MODULENAME}]=1

