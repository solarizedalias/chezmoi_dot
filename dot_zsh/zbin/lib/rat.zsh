
# vim: set ft=zsh:

# ==========================================================
# rat.zsh
# Tue Aug 18 09:17:38 2020
# AUTHOR: solarizedalias
#
# ==========================================================

function rat() {

  emulate -LR zsh
  setopt warn_create_global noclobber noappendcreate

  #
  # Parse args
  #
  (( $# )) || builtin set -- -
  builtin set -- ${(@)argv[1,${argv[(i)--]}-1]} ${(@)argv[${argv[(i)--]}+1,-1]}

  #
  # MAIN
  #
  (
  builtin zmodload zsh/system
  integer BUF_SIZE=1048575 READ F_SIZE ERRNO

  integer FD BYTES RET
  local F
  while (( $# )); do
    if [[ "${1}" == - ]]; then
      builtin sysread -s $(( BUF_SIZE )) -c BYTES -i 0 -o 1
    elif builtin sysopen -r -u FD "${1}"; then
      while builtin sysread -s $(( BUF_SIZE )) -c BYTES -i $(( FD )) -o 1; do
        continue
      done
      (( $? && $? != 5)) && RET=$?
      builtin exec {FD}<&-
    elif (( ERRNO )); then
      exit ERRNO
    fi
    shift
  done
  exit RET
  )
  return $?
}

