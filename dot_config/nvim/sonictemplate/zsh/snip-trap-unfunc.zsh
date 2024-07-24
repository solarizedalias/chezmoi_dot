
trap 'unset -f ${functions_source[(R)'${SOURCE:?}']}; autoload -Uz '${NAME:?}' ' EXIT
trap 'unset -f ${functions_source[(R)'${SOURCE:?}']}; autoload -Uz '${NAME:?}' return 1' INT

