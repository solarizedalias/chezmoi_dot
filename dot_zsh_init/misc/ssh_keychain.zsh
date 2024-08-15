
(( ${+commands[keychain]} )) || return 1

() {
  local D=${SSH_KEYCHAIN_KEY_LIST_DIR:-~/holocron}
  local FNAME=${SSH_KEYCHAIN_KEY_LIST_FILE:-ssh_keychain_key_list}
  local F=${D}/${FNAME}
  [[ -r ${F} ]] || return 1

  local -a keys
  keys=( ${(f)"$(<${F})"} )

  builtin eval "$(keychain -q --agents ssh --eval ${(@)keys})"
}
