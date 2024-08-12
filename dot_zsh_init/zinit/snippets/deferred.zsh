
(( ${+functions[is-at-least]} )) || autoload -Uz is-at-least
if is-at-least 5.8; then
  autoload -Uz fpx && fpx
fi
