
# vim: set ft=zsh.shellspec:

# ==========================================================
# is_zsh_spec
# Tue Jul 28 09:18:22 2020
# AUTHOR: solarizedalias
# Specfile for is_zsh
# ==========================================================

% UNPARSABLE_FILE:       "${SHELLSPEC_TMPBASE}/unparsable"
% PARSABLE_FILE:         "${SHELLSPEC_TMPBASE}/parsable"
% UNCOMPILABLE_FILE:     "${SHELLSPEC_TMPBASE}/uncompilable"
% COMPILABLE_FILE:       "${SHELLSPEC_TMPBASE}/compilable"
% WHITELISTED_FILE:      "${SHELLSPEC_TMPBASE}/.zshrc"
% WHITELISTED_DIR:       "${SHELLSPEC_TMPBASE}/share/zsh/functions"
% BLACKLISTED_FILE:      "${SHELLSPEC_TMPBASE}/LICENSE"
% BLACKLISTED_DIR:       "${SHELLSPEC_TMPBASE}/node_modules"

% NON_ZSH_SHEBANGED:     "${SHELLSPEC_TMPBASE}/non_zsh_shebanged"
% NON_ZSH_NOR_SHEBANGED: "${SHELLSPEC_TMPBASE}/non_zsh_nor_shebanged"
% ZSH_SHEBANGED:         "${SHELLSPEC_TMPBASE}/zsh_shebanged"
% ZSH_COMPDEFED:         "${SHELLSPEC_TMPBASE}/zsh_compdefed"
% ZSH_AUTOLOADED:        "${SHELLSPEC_TMPBASE}/zsh_autoloaded"

Include ./is_zsh

Describe 'is_blacklisted()'
  It 'returns 0 if $1 matches one of the blackdirs'
    When call is_blacklisted '/usr/local/some/dir/.git/some/object'
    The status should eq 0
  End
  It 'returns 1 if $1 does not match any of the blackdirs'
    When call is_blacklisted '/usr/local/share/zsh/do/not/exclude_me'
    The status should eq 1
  End

  It 'returns 0 if $1 matches one of the blacklist'
    When call is_blacklisted '/another/boring/foo.zwc'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_blacklisted '/some/things/never/go/well/license.md'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_blacklisted '/another/boring/Readme'
    The status should eq 0
  End
  It 'returns 0 if $1 matches one of the blacklist'
    When call is_blacklisted '/why/oh/why/readme.txt'
    The status should eq 0
  End

  It 'returns 1 if $1 does not match any of the blacklist'
    When call is_blacklisted '/This/is/not/supposed/to_be_excluded'
    The status should eq 1
  End
End

Describe 'is_whitelisted()'
  It 'returns 0 if $1 matches (file)'
    When call is_whitelisted '/some/place/zshrc'
    The status should eq 0
  End
  It 'returns 0 if $1 matches (file)'
    When call is_whitelisted '/some/place/.zcompdump'
    The status should eq 0
  End
  It 'returns 0 if $1 matches (dir)'
    When call is_whitelisted '/some/other/share/zsh/site-functions/_fantastic'
    The status should eq 0
  End

  It 'returns 1 if $1 does not match'
    When call is_whitelisted '/some/place/nothing/fancy'
    The status should eq 1
  End
End

Describe 'is_parsable()'
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
    When call is_parsable "${UNPARSABLE_FILE}"
    The status should be failure
  End
  It 'returns 0 if zsh can parse $1'
    When call is_parsable "${PARSABLE_FILE}"
    The status should be success
  End
End

Describe 'is_shebanged()'
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
    When call is_shebanged "${NON_ZSH_SHEBANGED}"
    The status should eq 1
    The stderr should not be present
  End
  It 'returns 1 if the first line is not a valid shebang'
    When call is_shebanged "${NON_ZSH_NOR_SHEBANGED}"
    The status should eq 1
    The stderr should not be present
  End
  It 'returns 0 if the shebang is for zsh'
    When call is_shebanged "${ZSH_SHEBANGED}"
    The status should eq 0
  End
  It 'returns 0 if the first line is #compdef'
    When call is_shebanged "${ZSH_COMPDEFED}"
    The status should eq 0
  End
  It 'returns 0 if the first line is #autoload'
    When call is_shebanged "${ZSH_AUTOLOADED}"
    The status should eq 0
  End
End

Describe 'compiles'
  make-uncompileable() {
    %text >| "${UNCOMPILABLE_FILE}"
    #| : ${VAR[this]:=SCRIPT}
    #| : ${VAR[looks]::=VALID}
    #| : ${(P)VAR[but]::=zsh -n SHOWS ERROR}
  }
  make-compileable() {
    %text >| "${COMPILABLE_FILE}"
    #| : ${VAR[this]:=SCRIPT}
    #| : ${VAR[looks]::=The Same as the last one}
    #| {
    #|   : ${(P)VAR[but]::=Surround with braces saves the world}
    #| }
  }
  setup() {
    make-uncompileable
    make-compileable
  }

  It 'returns 1 if $1 does not compile'
    When call compiles "${UNCOMPILABLE_FILE}"
    The status should eq 1
  End
  It 'succeeds if $1 compiles'
    When call compiles "${COMPILABLE_FILE}"
    The status should eq 1
  End

End

Describe 'is_zsh_file()'
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
    When call is_zsh_file '/some/project/.gitignore'
    The status should eq 1
  End
  # It 'returns 0 if $1 is whitelisted'
  #   When call is_zsh_file '/some/place/.zprofile'
  #   The status should eq 0
  # End
  # It 'returns 0 if $1 is whitelisted'
  #   When call is_zsh_file '/compile/this/.zshrc'
  #   The status should eq 0
  # End

  It 'returns 1 if shebanged file does not compile'
    When call is_zsh_file "${ZSH_SHEBANGED}"
    The status should eq 1
  End

  It 'returns error if $1 is an unparsable files'
    When call is_zsh_file "${UNPARSABLE_FILE}"
    The status should be failure
  End

  It 'returns 0 if $1 does not have shebang but syntactically valid (zsh can parse it).'
    When call is_zsh_file "${PARSABLE_FILE}"
    The status should be success
  End
End

# ******************************
#             Main
# ******************************
Describe 'main block'
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
  create_files() {
    mkdir -p ${WHITELISTED_DIR} && touch ${WHITELISTED_DIR}/{not_to_compile.zwc,not_this.zwc.old,compile_this.zsh}
    mkdir -p ${BLACKLISTED_DIR} && touch ${BLACKLISTED_DIR}/not_to_compile.zsh
    touch ${WHITELISTED_FILE}
    touch ${BLACKLISTED_FILE}
  }
  setup() {
    create_unparsable
    create_parsable
    create_files
  }
  cleanup() {
    rm ${SHELLSPEC_TMPBASE:?}/*(N-.)
  }

  Data:expand
    #|${WHITELISTED_DIR}/not_to_compile.zwc
    #|${BLACKLISTED_DIR}/not_to_compile.zsh
    #|${WHITELISTED_FILE}
    #|${BLACKLISTED_FILE}
    #|${UNPARSABLE_FILE}
    #|${PARSABLE_FILE}
  End

  Before "setup"
  After  "cleanup"

  It 'prints only zsh files'
    When run script ./is_zsh
    The stdout should be present
    The line 1 of stdout should eq "${WHITELISTED_FILE}"
    The line 2 of stdout should eq "${PARSABLE_FILE}"
    The stdout should not include 'not_to_compile'
    The stdout should not include "${BLACKLISTED_FILE}"
    The stdout should not include "${BLACKLISTED_DIR}"
    The stdout should not include "${UNPARSABLE_FILE}"
  End
End

