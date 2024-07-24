
local THISFILE LIB_ID
THISFILE="${${(%):-%N}:a}"
LIB_ID="${THISFILE:t}"

:<<'MODULE_USAGE'
Usage: ${LIB_ID}
  ${LIB_ID} is a general utility for generating brief usage for help text.
  ${LIB_ID} defines a single shell function usage(), which output a code block described by the here document $1.

Examples:
  case \\${1:-} in
    (-h|--help)
      eval "\\$(usage "USAGE" < "\\$0")"
    ;;
  esac

MODULE_USAGE

function usage() {
  local TARGET
  local -a match mbegin mend
  TARGET="$(</dev/stdin)"
  if [[ "${TARGET}" == (#I)*$'\n'(#b)(*'<<'\'$1\')*$'\n'($1)* ]]; then
    print -- "${${TARGET[mbegin[1],mend[2]]}:s@${match[1]}@cat<<$1}"
  fi

}

if (( ${(%):-%e} < 2 )) && [[ $@ == (-h|--help) ]] ; then
  eval "$(usage MODULE_USAGE < ${THISFILE})"
fi

