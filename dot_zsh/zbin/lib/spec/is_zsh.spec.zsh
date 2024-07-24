
# vim: set ft=zsh.shellspec:

# ==========================================================
# is_zsh_spec
# 2020-07-28T18:52:45
# AUTHOR: solarizedalias
# Specfile for lib/is_zsh.zsh
# ==========================================================

% UNPARSABLE_FILE:       "${SHELLSPEC_TMPBASE}/unparsable"
% PARSABLE_FILE:         "${SHELLSPEC_TMPBASE}/parsable"
% WHITELISTED_FILE:      "${SHELLSPEC_TMPBASE}/.zshrc"
% WHITELISTED_DIR:       "${SHELLSPEC_TMPBASE}/share/zsh/functions"
% BLACKLISTED_FILE:      "${SHELLSPEC_TMPBASE}/LICENSE"
% BLACKLISTED_DIR:       "${SHELLSPEC_TMPBASE}/node_modules"

% NON_ZSH_SHEBANGED:     "${SHELLSPEC_TMPBASE}/non_zsh_shebanged"
% NON_ZSH_NOR_SHEBANGED: "${SHELLSPEC_TMPBASE}/non_zsh_nor_shebanged"
% ZSH_SHEBANGED:         "${SHELLSPEC_TMPBASE}/zsh_shebanged"
% ZSH_COMPDEFED:         "${SHELLSPEC_TMPBASE}/zsh_compdefed"
% ZSH_AUTOLOADED:        "${SHELLSPEC_TMPBASE}/zsh_autoloaded"

Include ./is_zsh.zsh

Describe 'is_zsh::is_blacklisted()'
  It 'returns 0 if $1 matches one of the blackdirs'
    When call is_zsh::is_blacklisted '/usr/local/some/dir/.git/some/object'
    The status should eq 0
  End
  It 'returns 1 if $1 does not match any of the blackdirs'
    When call is_zsh::is_blacklisted '/usr/local/share/zsh/do/not/exclude_me'
    The status should eq 1
  End

  It 'returns 0 if $1 matches one of the blacklist'
    When call is_zsh::is_blacklisted '/another/boring/foo.zwc'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_zsh::is_blacklisted '/some/things/never/go/well/license.md'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_zsh::is_blacklisted '/another/boring/Readme'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_zsh::is_blacklisted '/why/oh/why/readme.txt'
    The status should eq 0
  End

  It 'returns 1 if $1 does not match any of the blacklist'
    When call is_zsh::is_blacklisted '/This/is/not/supposed/to_be_excluded'
    The status should eq 1
  End
End

Describe 'is_zsh::is_whitelisted()'
  It 'returns 0 if $1 matches (file)'
    When call is_zsh::is_whitelisted '/some/place/zshrc'
    The status should eq 0
  End
  It 'returns 0 if $1 matches (file)'
    When call is_zsh::is_whitelisted '/some/place/.zcompdump'
    The status should eq 0
  End
  It 'returns 0 if $1 matches (dir)'
    When call is_zsh::is_whitelisted '/some/other/share/zsh/site-functions/_fantastic'
    The status should eq 0
  End

  It 'returns 1 if $1 does not match'
    When call is_zsh::is_whitelisted '/some/place/nothing/fancy'
    The status should eq 1
  End
End

Describe 'is_zsh::is_parsable()'
  create_unparsable() {
    %text > "${UNPARSABLE_FILE}"
    #| Unexpected toke do { done
    #| '''foo
    #| ;;
    #| :
    #| :
  }
  create_parsable() {
    %text > "${PARSABLE_FILE}"
    #|#!/usr/bin/false
    #|echo this is a valid
    #|true && print zsh code
  }
  setup() {
    create_unparsable
    create_parsable
  }
  cleanup() {
    rm ${SHELLSPEC_TMPBASE:?}/*(N-.)
  }

  Before "setup"
  After  "cleanup"
  It 'returns error if zsh cannot parse $1'
    When call is_zsh::is_parsable "${UNPARSABLE_FILE}"
    The status should be failure
  End
  It 'returns 0 if zsh can parse $1'
    When call is_zsh::is_parsable "${PARSABLE_FILE}"
    The status should be success
  End
End

Describe 'is_zsh::is_shebanged()'
  create_non_zsh_shebanged() {
    %text > "${NON_ZSH_SHEBANGED}"
    #|#!/this/is/not/zsh/shebang
    #|#!/this/is/not/to/be/considered/as/zsh
    #|false && who --cares $anything "else"
  }
  create_non_zsh_nor_shebanged() {
    %text > "${NON_ZSH_NOR_SHEBANGED}"
    #|#this-is-not-a-valid-shebang
    #|: >/dev/null
    #|
  }
  create_zsh_shebanged() {
    %text > "${ZSH_SHEBANGED}"
    #|#!/this/should/be/considered/as/zsh
    #|: what else do you want '?'
  }
  create_zsh_compdefed() {
    %text > "${ZSH_COMPDEFED}"
    #|#compdef fancy
    #|
    #|_arguments -S \
    #| '1: :(foo baz bar)' && ret=0
    #| return ret
    #|
  }
  create_zsh_autoloaded() {
    %text > "${ZSH_AUTOLOADED}"
    #|#autoload
    #|
    #|: do something
  }
  setup() {
    create_non_zsh_shebanged
    create_non_zsh_nor_shebanged
    create_zsh_shebanged
    create_zsh_compdefed
    create_zsh_autoloaded
  }
  cleanup() {
    rm ${SHELLSPEC_TMPBASE}/*(N-.)
  }
  Before "setup"
  After  "cleanup"

  It 'returns 1 if shebang is not for zsh'
    When call is_zsh::is_shebanged "${NON_ZSH_SHEBANGED}"
    The status should eq 1
    The stderr should not be present
  End
  It 'returns 1 if the first line is not a valid shebang'
    When call is_zsh::is_shebanged "${NON_ZSH_NOR_SHEBANGED}"
    The status should eq 1
    The stderr should not be present
  End
  It 'returns 0 if the shebang is for zsh'
    When call is_zsh::is_shebanged "${ZSH_SHEBANGED}"
    The status should eq 0
  End
  It 'returns 0 if the first line is #compdef'
    When call is_zsh::is_shebanged "${ZSH_COMPDEFED}"
    The status should eq 0
  End
  It 'returns 0 if the first line is #autoload'
    When call is_zsh::is_shebanged "${ZSH_AUTOLOADED}"
    The status should eq 0
  End
End

Describe 'is_zsh::is_zsh_file()'
  create_unparsable() {
    %text > "${UNPARSABLE_FILE}"
    #| Unexpected toke do { done
    #| '''foo
    #| ;;
    #| :
    #| :
  }
  create_parsable() {
    %text > "${PARSABLE_FILE}"
    #|: NO SHEBANG
    #|echo this is a valid
    #|true && print zsh code
  }
  create_non_zsh_shebanged() {
    %text > "${NON_ZSH_SHEBANGED}"
    #|#!/this/is/not/zsh/shebang
    #|#!/this/is/not/to/be/considered/as/zsh
    #|false && who --cares $anything "else"
  }
  create_non_zsh_nor_shebanged() {
    %text > "${NON_ZSH_NOR_SHEBANGED}"
    #|#this-is-not-a-valid-shebang
    #|: >/dev/null
    #|
  }
  create_zsh_shebanged() {
    %text > "${ZSH_SHEBANGED}"
    #|#!/this/should/be/considered/as/zsh
    #|: But zsh cannnot understands the line below
    #|;; then do done
  }
  create_zsh_compdefed() {
    %text > "${ZSH_COMPDEFED}"
    #|#compdef fancy
    #|
    #|_arguments -S \
    #| '1: :(foo baz bar)' && ret=0
    #| return ret
    #|
  }
  create_zsh_autoloaded() {
    %text > "${ZSH_AUTOLOADED}"
    #|#autoload
    #|
    #|: do something
  }

  setup() {
    create_unparsable
    create_parsable
    create_non_zsh_shebanged
    create_non_zsh_nor_shebanged
    create_zsh_shebanged
    create_zsh_compdefed
    create_zsh_autoloaded
  }
  cleanup() {
    rm ${SHELLSPEC_TMPBASE:?}/*(N-.)
  }

  Before "setup"
  After  "cleanup"

  It 'returns 1 if $1 is blacklisted'
    When call is_zsh::is_zsh_file '/some/project/.gitignore'
    The status should eq 1
  End
  It 'returns 0 if $1 is whitelisted'
    When call is_zsh::is_zsh_file '/some/place/.zprofile'
    The status should eq 0
  End
  It 'returns 0 if $1 is whitelisted'
    When call is_zsh::is_zsh_file '/compile/this/.zshrc'
    The status should eq 0
  End

  It 'returns 1 if shebanged file is unparsable'
    When call is_zsh::is_zsh_file "${ZSH_SHEBANGED}"
    The status should eq 1
  End

  It 'returns error if $1 is an unparsable files'
    When call is_zsh::is_zsh_file "${UNPARSABLE_FILE}"
    The status should be failure
  End

  It 'returns 0 if $1 does not have shebang but syntactically valid (zsh can parse it).'
    When call is_zsh::is_zsh_file "${PARSABLE_FILE}"
    The status should be success
  End
End

