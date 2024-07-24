# Describe "Sample specfile"
#   Describe "hello()"
#     hello() {
#       echo # "hello $1"
#     }

#     It "puts greeting, but not implemented"
#       Pending "You should implement hello function"
#       When call hello world
#       The output should eq "hello world"
#     End
#   End
# End


Describe 'stop-brewlet-and-watcher.zsh'
  Include ./lib/f_stop-brewlet-and-watcher.zsh

  Describe 'find_procs()'
    It 'should set params to the procs found.'
      local -a watch_procs=()
      integer BREWLET_PROC=0
      pgrep() {
        case $1 in
          (-f)
            shift
          ;;
        esac
        [[ "$*" == *zsh* ]] && echo "11111 22222"
        [[ "$*" == *Brewlet\\.app* ]] && echo "33333"
        return 0
      }
      When call find_procs
      The status should eq 0
      The value "${watch_procs[1]}" should eq 11111
      The value "${watch_procs[2]}" should eq 22222
      The value "${BREWLET_PROC}"   should eq 33333
    End
    It 'should return 1 if the target process(es) cannot be found.'
      pgrep() { return 1 }
      When call find_procs
      The status should eq 1
    End
  End

  Describe 'check_remainder()'
    It 'should return 0 if find_procs() finds nothing'
      find_procs() { return 1 }
      When call check_remainder
      The status should eq 0
    End
    It 'should return 1 if any of the procs is found'
      find_procs() { return 0 }
      When call check_remainder
      The status should eq 1
    End
  End

  Describe 'kill_watchers()'
    kill() { print -l $@ }
    local -a watch_procs=( 11111 22222 33333 44444 )
    It 'should call `kill` with ${(@)watch_procs} as args.'
      When call kill_watchers
      The output should eq "11111
22222
33333
44444"
    End
  End

  Describe 'quit_or_kill_Brewlet()'
    local -a _osascript_ _pkill_
    osascript() { _osascript_=($@) }
    pgrep() { return 0 }
    pkill() { _pkill_=($@) }
    It 'should call osascript to quit Brewlet'
      When call quit_or_kill_Brewlet
      The value "${_osascript_[*]}" should eq "-e quit app \"Brewlet\""
    End
    It 'should call pkill if pgrep succeeds'
      When call quit_or_kill_Brewlet
      The value "${(@)_pkill_}" should eq "Brewlet"
    End
  End

  Describe 'main()'
    find_procs()           { return 0 }
    kill_watchers()        { return 0 }
    quit_or_kill_Brewlet() { return 0 }
    check_remainder()      { return 0 }

    It 'should throw early if find_procs fails'
      find_procs() { return 1 }
      When run main
      The stderr should be present
      The status should be failure
    End

    It 'should call kill_watchers() and then call quit_or_kill_Brewlet only if kill_watchers succeeds.'
      : # TODO
    End

    It 'should print "Good." if check_remainder succeeds'
      When run main
      The status should eq 0
      The output should eq "Good."
    End

    It 'should print "Bad." if check_remainder fails'
      check_remainder() { return 1 }
      When run main
      The status should eq 1
      The output should eq "Bad."
    End

  End
End

