#!/usr/bin/env zsh

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern


() {

  readonly SOURCE="${${(%):-%x}:a}"
  readonly NAME="${SOURCE:t}"
  readonly HEAD="${SOURCE:h}"

  function ${NAME}::parse() {
    local -a keywords
    local -a input=( ${(f)"$(</dev/stdin)"} )

    # What this scary thing does is
    #   * Store JSON keys as `key:::`.
    #   * (Hopefully) change nothing else.
    # eval is needed to remove double quotes.
    # (Q) will expand other things (\n, \t) as well...sadly.
    local -a parsed=(
      ${(@)${(@)${(f)"$(
        eval "
          print -rl -- ${(@)${(f)${(F)${(s:,,,:)${(@)input//(#b)([\"\}]|[\]]|$'\n')[[:blank:]]#([,:])/${match[1]}${match[2]}${match[2]}${match[2]}}}}}//(#m)([\{\}\[\]\(\)])/\\${MATCH}}
        "
      )"//\\(#b)([\[\]\{\}\(\)])/${match[1]}}:#[\[\]\{\}]}//(#b)(true|false|null|[0-9.]##),/${match[1]}}
    )

    print -rl -- ${(@)parsed}
  }

  if (( ${(%):-%e} < 2 )); then
    ${NAME}::parse </dev/stdin
  fi
}

