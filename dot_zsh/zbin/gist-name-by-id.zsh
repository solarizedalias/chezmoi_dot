#!/usr/bin/env zsh

# ==========================================================
# gist-name-by-id
# Thu Sep  3 13:49:03 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

readonly SOURCE="${${(%):-%N}:a}"
readonly NAME="${SOURCE:t}"
readonly HEAD="${SOURCE:h}"

local URL_BASE="https://api.github.com/gists"



#
# PARSE PARAMETERS
#
local -a opts users tokens
zparseopts -a opts -D -K -M -E \
  h -help=h \
  v -version=v \
  u:=users -users:=u \
  t:=tokens -token:=t

local -a optcurl
local UT
(( ${users[(I)^(-u|--user)]} )) && UT="${users[(R)^(-u|--user)]}"
(( ${users[(I)^(-t|--token)]} )) && UT="${UT}:${tokens[(R)^(-t|--token)]}"
[[ -n ${UT} ]] && optcurl+=( -u ${UT} )

function fetch() {
  integer RET=0
  for id in $@; do
    curl -fsSL ${(@)optcurl} -- ${URL_BASE}/${id} || print -rl -- "Failure:$(( ++RET )): ${id} " >&2
  done
  return RET
}

function parse-response() {
  local -a keywords
  local -a input=( ${(f)"$(</dev/stdin)"} )
  local -a patterns=(
    files:::
    description:::
  )

  # What this scary thing does is
  #   * Store JSON keys as `key:::`.
  #   * (Hopefully) change nothing else.
  # eval is needed to remove double quotes.
  # (Q) will expand other things (\n, \t) as well...sadly.
  local -a parsed=(
    ${(f)"$(
      eval "
        print -rl -- ${(@)${(@)${(f)${(F)${(s:,,,:)${(@)input//(#b)([\"\}]|[\]]|$'\n')([,:])/${match[1]}${match[2]}${match[2]}${match[2]}}}}}//(#m)([\{\}\[\]\(\)])/\\${MATCH}}}
      "
    )"//\\(#b)([\[\]\{\}])/${match[1]}}
  )

  for ((i = 1; i <= ${#parsed}; ++i)); do
    [[ ${parsed[i]} == (${(~pj:|:)patterns}) && ${parsed[i+1]} != *::: ]] && print -r -- ${parsed[i+1]}
  done
}

