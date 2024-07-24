
Include ./preview.zsh

Describe 'main()'
  It 'exit 1 if function KIND=$1 does not exists'
    unfunction nosuchfunc &>/dev/null || :
    When run main 'nosuchfunc'
    The status should eq 1
  End

  It 'print empty string if none of paths ${@[2,-1]} exists'
    dir() { :; }
    [[ -f /should/not/exist ]] && exit 1
    When call main 'dir' '' ' ' '/should/not/exist'
    The stdout should eq ''
    The status should eq 0
  End
End

