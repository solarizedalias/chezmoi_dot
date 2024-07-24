#!/usr/bin/env zsh
# vim: set ft=zsh:

# ==========================================================
# escape_posix_quotes
# Wed Aug 19 17:03:21 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern
setopt noclobber      noappendcreate

readonly BIN="${${(%):-%N}:a}"
readonly LIBD="${BIN:h}/lib"

local -a match mbegin mend

while read -r line; do
  print -- ${line//(#b)(\$|)([\'\"]##)(([^\"]|[\\][\'\"])##)([^\\])${match[2]}/${match[1]}${match[2]}${match[3]//\\/\\\\}${match[2]}}
done

