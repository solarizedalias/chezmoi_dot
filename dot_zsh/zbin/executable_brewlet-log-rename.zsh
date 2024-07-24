#!/usr/bin/env zsh
# vim: set ft=zsh:

# ==========================================================
# brewlet_log_rename
# Sat Jul  4 22:52:22 2020
# AUTHOR: solarizedalias
#
# ==========================================================

local -a files=( ~/.brewlet.log.d/*.log(N.) )
for file in ${(@)files}; do
  if [[ "${file}" == *-update-* ]] && grep '==> Upgrading [0-9]\+ outdated packages\?:' ${file} >/dev/null 2>&1; then
    mv ${file} ${file/update/upgrade}
  fi
done

