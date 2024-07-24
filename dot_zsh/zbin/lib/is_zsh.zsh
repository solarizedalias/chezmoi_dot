
emulate -L zsh
setopt typeset_silent no_auto_pushd hist_subst_pattern
setopt extended_glob  glob_dots     rc_quotes

local -a blackdirs=(
  '.git'
  'node_modules'
)

local -a blacklist=(
  '*.zwc'
  '*.zwc.old'
  '.git*'
  '*\~'
  '(#i)readme(.md|.txt)(#c0,1)'
  '(#i)license(.md|.txt)(#c0,1)'
  # Files with extentions but not [z]sh
  # Exclude a few known false positive.
  '*([^./][^/]#).([^./](#c1,))~(*.(zsh|sh)|*/(_invoke-rc.d|_update-rc.d))'
)

local -a whitelist=(
  '*.zsh'
  # common startup files
  '[.](#c0,1)(zshrc|zshenv|zprofile|zlogin|zlogout|zcompdump)'
)

# doesn't care what the actual files inside look like
# so make sure to use these only after blacklisting.
local -a white_dirs=(
  # common dirs.
  'share/zsh/site-functions'
  'share/zsh/functions'
)

function is_zsh::is_blacklisted() {
  local dir pat
  for dir in ${(@)blackdirs}; do
    [[ $1 == */${dir}/* ]] && return 0
  done

  for pat in ${(@)blacklist}; do
    [[ $1 == */${~pat}(#e) ]] && return 0
  done
  return 1
}

function is_zsh::is_whitelisted() {
  local dir pat
  for dir in ${(@)white_dirs}; do
    [[ $1 == */${dir}/* ]] && return 0
  done
  for pat in ${(@)whitelist}; do
    [[ $1 == */${~pat}(#e) ]] && return 0
  done
  return 1
}

function is_zsh::is_parsable() {
  zsh -n $1 2>/dev/null
}

#######################################
# Check if the 1st line is zsh-likely shebanged
# Arguments:
#   $1 Text file
#######################################
function is_zsh::is_shebanged() {
  local FIRST
  [[ -r "$1" ]] && read -r FIRST <"$1"
  [[ "${FIRST}" == (#s)(\#\!(/[^/]##)##/(zsh|env[[:space:]]##zsh)|\#(compdef|autoload))([[:space:]]*)#(#e) ]]
}

function is_zsh::is_zsh_file() {
  # First, exclude artefacts.
  if is_zsh::is_blacklisted $1; then
    return 1
  elif is_zsh::is_whitelisted $1 && ! is_zsh::is_blacklisted $1; then
    return 0
  # Check if the 1st line is zsh-likely.
  # And if so, check also if it is compilable.
  elif is_zsh::is_shebanged $1; then
    is_zsh::is_parsable $1 && return 0 || return 1
  # Then, pass through some well known names.
  elif is_zsh::is_whitelisted $1; then
    return 0
  # Check all the rest if they are syntactically valid zsh code.
  elif ! is_zsh::is_parsable $1; then
    return 1
  else
    return 0
  fi
}

