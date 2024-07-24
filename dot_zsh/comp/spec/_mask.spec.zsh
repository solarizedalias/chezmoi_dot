#!/usr/local/bin/zsh

#
# shellspec tests for _mask
#

eval "$(shellspec -)"

% MASK_TEST_FILE: "${SHELLSPEC_TMPBASE}/maskfile.md"

Describe '_mask'
  Include ./_mask
  Before "setup"
  After "cleanup"

  setup() {
    %text > "${MASK_TEST_FILE}"
    #|
    #|## test1
    #|> test command 1
    #|  **OPTIONS**
    #|
    #|  * opt1
    #|    * flags: --opt1
    #|    * type: string
    #|    * desc: Description for opt1
    #|  <!-- markdown comments may appear -->
    #|  * opt2
    #|    * flags: --opt2
    #|    * type: number
    #|    * desc: Description for opt2
    #|
    #|  ```zsh
    #|    # Code Block may appear
    #|    echo "This is a test."
    #|  ```
    #|
    #|## test2
    #|> test command 2 (nested command)
    #|
    #|### test2 sub1
    #|
    #|  **OPTIONS**
    #|
    #|  * subopt1
    #|    * flags: --sub-opt1
    #|    * type: string
    #|    * desc: Description for subopt1
    #|
    #|  * subopt2
    #|    * flags: --sub-opt2
    #|    * type: boolean
    #|    * desc: Description fro subopt2
    #|
    #|> Subcommand description for test2
    #|  ```zsh
    #|    echo "This is sub1"
    #|  ```
    #|
    #|
    #|
  }

  cleanup() {
    command trash "${MASK_TEST_FILE}"
  }

  Describe '__mask_find_options_for_one_task'
    local -a reply

    It 'should set reply to optspecs found in given the maskfile.md'
      When call __mask_find_options_for_one_task ${MASK_TEST_FILE} test1
      The status should be success
      The value "${reply[1]}" should eq "--opt1[Description for opt1]:string"
      The value "${reply[2]}" should eq "--opt2[Description for opt2]:number"
    End
  End
End
