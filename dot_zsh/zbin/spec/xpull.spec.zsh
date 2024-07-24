
# vim:ft=zsh.shellspec:foldmethod=indent:

#
#
#

emulate -L zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

Include ./xpull
SHELLSPEC_SHELL_OPTIONS="emulate -L zsh; setopt typeset_silent no_short_loops no_auto_pushd extended_glob  glob_dots rc_quotes hist_subst_pattern"

Describe 'top level preparations'
  It 'loads lib/std.zsh'
    When call true
    The variable 'Modules[std.zsh]' should eq 1
  End
  It 'sets up parameters targets:array=() DATE:scalar TEMP_BASE:scalar'
    When call true
    The variable 'targets' should be defined
    The variable 'targets' should be blank
    The variable 'DATE' should be present
    The variable 'TEMP_BASE' should be present
    The value "targets:${(t)targets}" should match pattern 'targets:array*'
    The value "DATE:${(t)DATE}" should match pattern 'DATE:scalar*'
    The value "TEMP_BASE:${(t)TEMP_BASE}" should match pattern 'TEMP_BASE:scalar*'
  End

End

Describe 'prepare_temp()'
  Context 'when the dir already exists'
    pre() {
      mkdir "${TEMP_BASE}"
    }
    post() {
      [[ -d "${TEMP_BASE}" ]] && rm -rf "${TEMP_BASE}"
    }
    Before pre
    After  post
    It 'throws if temp dir already exists'
      When run prepare_temp
      The status should be failure
      The stderr should eq "${TEMP_BASE} already exists."
    End
  End

  Context 'when the dir does not exist'
    mode() {
      (( ${+builtins[zstat]} )) || zmodload zsh/stat
      zstat -s ${TEMP_BASE} | grep '^mode' | awk '{print $2}'
    }
    It 'make the directory with the secure permission'
      When call prepare_temp
      The path "${TEMP_BASE}" should be empty directory
      The result of function mode should eq 'drwx------'
    End
  End
End

# xDescribe 'cleaup'
#   Todo 'skip for now'
# End

Describe 'setup-fifo()'
  It 'makes $#targets named-pipes at $TEMP_BASE'
    targets=(one two three)
    When call setup-fifo
    The path "${TEMP_BASE}/1" should be pipe
    The path "${TEMP_BASE}/2" should be pipe
    The path "${TEMP_BASE}/3" should be pipe
    The path "${TEMP_BASE}/4" should not be exist
    The path "${TEMP_BASE}/5" should not be exist
  End
End

Describe 'pull-all()'
  Context 'if pushd fails'
    integer -g COUNT=0
    git() {
      COUNT+=1
      echo $(( COUNT ))
      [[ $1 == pull ]] && return 0
      return 3
    }
    targets=(
      /no/such/directory/{one,two,three,four}
    )
    It 'skips if pushd fails'
      When call pull-all
      The variable COUNT should eq 0
      The line 1 of stderr should eq "pull-all:pushd:3: no such file or directory: /no/such/directory/one"
      The line 2 of stderr should eq "pull-all:pushd:3: no such file or directory: /no/such/directory/two"
      The line 3 of stderr should eq "pull-all:pushd:3: no such file or directory: /no/such/directory/three"
      The line 4 of stderr should eq "pull-all:pushd:3: no such file or directory: /no/such/directory/four"
    End
  End

  Context 'if pushd succeeds'
    pre() {
      mkdir -p ${SHELLSPEC_WORKDIR:?}/{one,two,three,four}
      for n in {1..4}; do
        [[ -p ${TEMP_BASE}/${n} ]] || mkfifo ${TEMP_BASE:?}/${n}
      done
      cat ${TEMP_BASE}/{1,2,3,4} >| ${SHELLSPEC_WORKDIR}/result &!
    }
    post() {
      [[ -d ${TEMP_BASE} ]] && rm -f ${TEMP_BASE}/{1,2,3,4}
      rm -rf ${SHELLSPEC_WORKDIR}/{one,two,three,four}
    }
    targets=(
      ${SHELLSPEC_WORKDIR:?}/{one,two,three,four}
    )
    (( ${#targets} == 4 )) || exit 3
    git() {
      echo "j is $j"
      [[ $1 == pull ]] && return 0
      return 3
    }
    Before pre
    After  post
    It 'calls git pull for each element in targets'
      When call pull-all
      The path "${SHELLSPEC_WORKDIR}/result" should be file
      The line 1 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq "${SHELLSPEC_WORKDIR##*/}/one"
      The line 2 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq 'j is 1'
      The line 3 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq "${SHELLSPEC_WORKDIR##*/}/two"
      The line 4 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq 'j is 2'
      The line 5 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq "${SHELLSPEC_WORKDIR##*/}/three"
      The line 6 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq 'j is 3'
      The line 7 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq "${SHELLSPEC_WORKDIR##*/}/four"
      The line 8 of contents of file "${SHELLSPEC_WORKDIR}/result" should eq 'j is 4'
      The lines of contents of file "${SHELLSPEC_WORKDIR}/result" should eq 8
    End
  End
End

Describe 'wait-fifo()'
  Context '**NOT** Already up to date.'
    targets=( one two three four five )
    writef() {
      for n in {1..5}; do
        [[ -p ${TEMP_BASE}/${n} ]] || return 3
        print -l "Line $n" >| ${TEMP_BASE}/${n} &
      done
    }

    caller() {
      wait-fifo >| ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result &
      writef
      wait $!
      return $?
    }
    pre() {
      mkfifo ${TEMP_BASE:?}/{1..5}

      for p in ${TEMP_BASE}/{1..5}; do
        [[ -p $p ]]
      done
    }

    post() {
      rm -f ${TEMP_BASE:?}/*(ND-p)
    }

    Before pre
    # After post

    It 'reads fifo 1..${#targets}'
      When call caller
      The status should be success
      The line 1 of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 'Line 1'
      The line 2 of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 'Line 2'
      The line 3 of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 'Line 3'
      The line 4 of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 'Line 4'
      The line 5 of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 'Line 5'
      The lines of contents of file ${SHELLSPEC_WORKDIR}/${SHELLSPEC_EXAMPLE_ID}.result should eq 5
    End
  End
End

# Describe 'delte-if-terminal()'

# End

Describe 'get-repositories()'
  Context 'Invalid param `targets`'
    It 'throws if targets is not set.'
      unset targets
      When run get-repositories NOP
      The status should be failure
      The stderr should eq 'Array `targets` is not set.'
    End

    It 'throws if targets is not an array.'
      typeset targets=500000
      When run get-repositories NOP
      The status should be failure
      The stderr should eq 'Type Error: Expected array `targets`. Received ('${(t)targets}').'
    End
  End

  Context 'Invalid calling conventions'
    It 'throws if $1 is not given.'
      When run get-repositories
      The status should be failure
      The stderr should match pattern 'get-repositories:*: parameter not set'
    End
  End

  Context 'No repositories found'
    pre() {
      mkdir -p ${SHELLSPEC_WORKDIR}/mock/{one,two,three,four}/{not,git,repo,foo}
    }
    It 'throws if no repositories found in $1'
      When run get-repositories ${SHELLSPEC_WORKDIR}
      The status should be failure
      The stderr should eq "No git repository found in ${SHELLSPEC_WORKDIR}."
    End
  End

  Context 'OK'
    pre() {
      mkdir -p ${SHELLSPEC_WORKDIR}/mock/{one,two,three,four}/{A,B,C,D}/{a,b,c,d}
      touch ${SHELLSPEC_WORKDIR}/mock/two/C/.git
      mkdir -p ${SHELLSPEC_WORKDIR}/mock/four/A/d/.git
    }
    assert() {
      (( ${#targets} )) || return 127
      [[ ${targets[1]} == ${SHELLSPEC_WORKDIR}/mock/four/A/d ]] || return 1
      [[ ${targets[2]} == ${SHELLSPEC_WORKDIR}/mock/two/C ]] || return 2
    }
    Before pre
    It 'adds repositories found to the array `targets`'
      When call get-repositories "${SHELLSPEC_WORKDIR}/mock"
      The status should be success
      Assert assert
    End

  End
End

Describe 'colorize()'
  Context 'no color'
    local TEXT="FOOBAZBAR"
    data() {
      print -- ${TEXT}
    }
    Data data
    It 'passes through the stdout as is.'
      When call colorize
      The output should eq "$(data)"
    End
  End

  xContext 'with color'
    data() {
      #|Updating 9ca55b8..3a41f98
      #|Fast-forward
      #| brw                          |   7 +-
      #| comp/_typeof                 |  22 +++++
      #| zbin/git-xpull               | 127 ++++++++++++++++++++++++
      #| zbin/lib/rat.zsh             |  26 +++++
      #| zbin/lib/std.zsh             |  31 ++++++
      #| zbin/lib/usage.zsh           |  33 +++++++
      #| zbin/rat                     |  24 +++++
      #| zbin/spec/git-xpull.spec.zsh | 228 +++++++++++++++++++++++++++++++++++++++++++
      #| zsh-users---zsh              |   2 +-
      #| zutils                       |   3 +
      #| 10 files changed, 496 insertions(+), 7 deletions(-)
      #| create mode 100644 comp/_typeof
      #| create mode 100644 zbin/git-xpull
      #| create mode 100644 zbin/lib/rat.zsh
      #| create mode 100644 zbin/lib/std.zsh
      #| create mode 100644 zbin/lib/usage.zsh
      #| create mode 100755 zbin/rat
      #| create mode 100644 zbin/spec/git-xpull.spec.zsh
    }

    stripansi() {
      echo "$@" | sed 's/\x1b\[[0-9;]*m//g'
    }
    Data data
    It 'passes through the stdout'
      When call colorize
      The output should not eq "$(data)"
      The result of function stripansi should eq "$(data)"
    End
  End
End

Describe 'main()'
  It 'throws if $1 is not a valid directory'
    When run main /NO/SUCH/DIRECTORY
    The status should be failure
    The stderr should eq '/NO/SUCH/DIRECTORY is not a directory'
  End
End

[[ -d ${TEMP_BASE} ]] && rm -rf ${TEMP_BASE}

