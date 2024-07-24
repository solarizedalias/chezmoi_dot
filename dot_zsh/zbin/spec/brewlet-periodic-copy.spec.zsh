
# vim: set ft=zsh.shellspec:

# ==========================================================
# brewlet_periodic_copy_spec.zsh
# Sun Aug  9 11:12:13 2020
# AUTHOR: solarizedalias
#
# ==========================================================

local FILE="${${:-./brewlet-periodic-copy.zsh}:a}"
local NAME="${FILE:t}"
Include ./brewlet-periodic-copy.zsh

Describe 'check_instaces'
  It 'exits if pgrep succeeds'
    pgrep() {
      return 0
    }
    When run "${NAME}::check_instaces"
    The status should be failure
    The stderr should eq "${NAME} is already running"
  End

End
