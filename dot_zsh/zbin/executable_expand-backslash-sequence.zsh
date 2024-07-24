#!/usr/bin/env zsh
# vim: set ft=zsh:

# ==========================================================
# expand_backslash_sequence
# Wed Aug 19 17:31:50 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -LR zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes hist_subst_pattern

local INPUT
INPUT="$(</dev/stdin)"

local -A EscapeSequence
EscapeSequence=(
  0 $'\0'
  1 $'\1'
  2 $'\2'
  3 $'\3'
  4 $'\4'
  5 $'\5'
  6 $'\6'
  7 $'\7'
  a $'\a'
  b $'\b'
  e $'\e'
  f $'\f'
  n $'\n'
  r $'\r'
  t $'\t'
  u $'\u'
  v $'\v'
  x $'\x'
)

local -a match mbegin mend

# print -r -- ${INPUT}

# local L='${EscapeSequence[' R=']}'

# INPUT="${INPUT//(#b)\\([01234567abefnrtuv])/${L}${match[1]}${R}}"

# print -- "$( print -- ${INPUT} )"

# INPUT="$(eval print -r -- ${INPUT})"
INPUT="${"$( print -r -- '$'${(q+)INPUT//\$/\\\$})"}"
INPUT="${INPUT//[\'](#c2)((#b)(|[^\\\'])(([\\][01234567abefnrtuvx\'])##)([^\\\']|))[\'](#c2)/''${(b)match[1]:-}${(b)match[2]}${(Z:n:)${(b)match[3]:-}}''}"
INPUT="${INPUT//[\'](#c2)/\'}"
eval 'print -r -- ${(Q)INPUT}'


# print ${INPUT} | sed 's/\${EscapeSequence\[\([abefnrtuv]\)\]}/\$''\\\1''/g'


