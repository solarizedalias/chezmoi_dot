#!/usr/bin/env zsh

# ==========================================================
# preview
# Thu Oct 22 11:00:22 2020
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -R zsh
setopt extended_glob      glob_dots           rc_quotes
setopt typeset_silent     hist_subst_pattern
setopt NO_clobber         NO_append_create    NO_auto_pushd no_short_loops

function text() {
  command bat --color=always $@
}

local -a args_exa=(
  --color=always
  -alhF
  --group-directories-first
  --git
)

# FIXME: exa is no more; we have eza instead.

function dir-no-ignore() {
  command exa  ${(@)args_exa} $@
}

function dir-ignore() {
  command exa ${(@)args_exa} --git-ignore --ignore-glob='*.zwc' $@
}

function dir() {
  local -a reply
  reply=( ${(f)"$( dir-ignore $@)"} )
  if [[ ${(@)reply} == *[[:graph:]]* ]]; then
    builtin print -rl -- ${(@)reply}
  else
    dir-no-ignore $@
  fi
}

function markdown() {
  command mdcat $@
}

function binary() {
  if [[ -x $1 || ${1:e} == (a|dylib) ]]; then
    my_ldd $@
  else
    command hexyl --color=always $@
  fi
}

function my_ldd() {
  local -a cmd_ldd
  if (( ${+commands[otool]} )); then
    cmd_ldd=( otool -L )
  elif (( ${+commands[ldd]} )); then
    cmd_ldd=( ldd )
  else
    print -u2 "we need either otool or ldd but found none"
    return 1
  fi
}

function zwc() {
  builtin zcompile -t $@
}

function readlines() {
  local REF="${1:-reply}"
  : ${(PA)REF::=${(f)"$( ${@[2,-1]:-:} )"}}
}

function auto() {
  if [[ -d $1 ]]; then
    dir $@
  elif [[ ${1:e} == zwc ]]; then
    zwc $@
  elif [[ "$( command file --brief --mime-type $1 )" == (text/*|application/(json|javascript)) ]]; then
    if [[ ${1:e} == (md|markdown) ]]; then
      markdown $@
    else
      text $@
    fi
  else
    binary $@
  fi
}

function main() {
  local KIND="$1"
  local -a reply
  if (( ${+functions[${KIND}]} < 1 )); then
    builtin exit 1
  fi
  shift
  local -a t_paths=( ${^@}(ND-:a) )
  if (( ${#t_paths} )); then
    readlines reply ${KIND} ${(@)t_paths}
    if [[ ${(@)reply} == *[[:graph:]]* ]]; then
      print -rl -- ${(@)reply}
    else
      print $'\n\n\n'
    fi
  else
    print $'\n\n\n'
  fi
}

# shellspec
${__SOURCED__:+return}

main $@

