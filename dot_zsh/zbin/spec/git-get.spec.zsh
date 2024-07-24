
# ==========================================================
# git_get_spec.zsh
# Thu Sep  3 11:40:35 2020
# AUTHOR: solarizedalias
# Specfile for git-get
# ==========================================================

emulate -R zsh
setopt typeset_silent no_short_loops no_auto_pushd
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern

Include ./git-get

Describe 'dispatch()'
  do-clone() {
    print -r -- $2
  }
  It 'parses gist url'
    When call dispatch 'https://gist.github.com/someone/1f4d0a3cb89d68d3256615f247e2aac9'
    The stdout should eq "${SRCROOT:?}/gist.github.com/someone/1f4d0a3cb89d68d3256615f247e2aac9"
  End

  It 'parses ssh url'
    When call dispatch 'git@github.com:owner/repo.git'
    The stdout should eq "${SRCROOT}/github.com/owner/repo"
  End

  It 'parses https url'
    When call dispatch 'https://some-other.org/foo/bar/baz'
    The stdout should eq "${SRCROOT}/some-other.org/foo/bar/baz"
  End

  It 'parses git url'
    When call dispatch 'git://gitlab.com/some/fancy/project.git'
    The stdout should eq "${SRCROOT}/gitlab.com/some/fancy/project"
  End

  It 'assumes github.com if owner/repo is given'
    When call dispatch 'owner/repo.git'
    The stdout should eq "${SRCROOT}/github.com/owner/repo"
  End

  It 'assumes me if repo is given'
    When call dispatch 'scrap'
    The stdout should eq "${SRCROOT}/github.com/$(git config --global --get user.name)/scrap"
  End

  It 'is rude if you''re dumb'
    When call dispatch 'goofy://doobie/shoogie.loony'
    The stderr should be present
  End
End

