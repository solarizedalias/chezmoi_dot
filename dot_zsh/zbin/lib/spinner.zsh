
# vim:ft=zsh:

# ==========================================================
# spinner
# Tue Aug 18 20:21:34 2020
# AUTHOR: solarizedalias
# Minimal implementation of a spinner.
# ==========================================================

function spinner() {
  if [[ $1 == [0-9]##(.[0-9])(#c0,1)[0-9]# ]]; then
    INTERVAL="$1"
    shift
  else
    INTERVAL="0.25"
  fi
  integer COUNTER=0
  local -a spinners=(
    '|' '/' '-' '\'
  )
  while sleep ${INTERVAL}; do
    printf '\r%s %s' ${spinners[( ++COUNTER % 4 ) + 1]} "$*"
  done
}

#
# Intended to be called inside a while loop or such.
# $1  --- Reference to COUNTER Variable.
# $2? --- INTERVAL (Optional) (Default: 0.25)
function spinnerX() {

  if [[ ${(Pt)1} == 'integer'*~*'local' ]]; then
    local CREF="$1" && shift
  else
    eval 'integer -g "COUNTER$TTY"'
    local CREF="COUNTER$TTY"
  fi

  if [[ $1 == [0-9]##(.[0-9])(#c0,1)[0-9]# ]]; then
    INTERVAL="$1"
    shift
  else
    INTERVAL="0.25"
  fi

  local -a spinners=(
    '|' '/' '-' '\'
  )

  : ${(P)CREF::=$(( ${(P)CREF} + 1 ))}
  sleep ${INTERVAL} && printf '\r%s %s' ${spinners[( ${(P)CREF} % 4 ) + 1]} "$*"
}

