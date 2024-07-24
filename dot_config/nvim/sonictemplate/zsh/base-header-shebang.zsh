#!/usr/bin/env zsh

# ==========================================================
# {{_name_}}
# {{_expr_:strftime('%c')}}
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

# {{_cursor_}}

