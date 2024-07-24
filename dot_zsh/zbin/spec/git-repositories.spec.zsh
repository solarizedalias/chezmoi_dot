
Include ./git-repositories

Describe 'find-git'
  Context '$1 is not a directory'
    It 'aborts if $1 is not a directory'
      When call find-git '/NO/SUCH/DIRECTORY'
      The status should eq 2
    End
  End

  xContext '$1 is a directory'
    : TODO
  End
End

Describe 'trim-ends'
  It 'trims the last /.git for each line'
    Data
      #|/foo/baz/bar/.git
      #|/foo/baz/barbar
      #|./foo/baz/barbarbar/.git
      #|/foo/baz/bar/.gitnot
    End
    When call trim-ends
    The lines of stdout should eq 4
    The line 1 of stdout should eq '/foo/baz/bar'
    The line 2 of stdout should eq '/foo/baz/barbar'
    The line 3 of stdout should eq './foo/baz/barbarbar'
    The line 4 of stdout should eq '/foo/baz/bar/.gitnot'
  End
End


Describe 'filter-ends'
  It 'filters out any element in skips'
    Data
      #|/do/not/filter/me
      #|/do/filter/me
      #|./not/to/be/excluded/.git
      #|./to/be/excluded/.git
    End
    local -a skips=(
      '/do/filter/me'
      './to/be/excluded/.git'
    )
    When call filter-skips
    The lines of stdout should eq 2
    The line 1 of stdout should eq '/do/not/filter/me'
    The line 2 of stdout should eq './not/to/be/excluded/.git'
  End
End

