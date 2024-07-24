#!/usr/bin/env zsh

# https://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
# Then ${0:h} to get plugin’s directory

readonly ZBIN="${0:h}"
source ${ZBIN}/lib/f_stop-brewlet-and-watcher.zsh

main

