
# vim:syntax=zsh.shellspec:

# ==========================================================
# std
# Sat Aug 22 14:53:25 2020
# AUTHOR: solarizedalias
#
# ==========================================================

Describe 'Top level status'
  Include ./std.zsh
  It 'sets variables THISMODULE MODULENAME MODULEDIR'
    When call :
    The variable THISMODULE should eq ./std.zsh(:a)
    The variable MODULENAME should eq std.zsh
    The variable MODULEDIR should eq .(:a)
  End
End

Describe 'Modules'
  unset Modules
  Include ./std.zsh
  Context 'is unset'
    It 'creates a new hash Modules when it does not exist.'
      When call :
      The variable Modules should be defined
      The variable Modules\[std.zsh\] should be defined
      The variable Modules\[std.zsh\] should eq 1
    End
  End
End

