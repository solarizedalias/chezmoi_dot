

# ==========================================================
# unplugged_spec
# Sat Oct  3 18:20:08 2020
# AUTHOR: solarizedalias
#
# ==========================================================

Include ./unplugged.zsh

Describe 'plug-it-now-or-i-will-get-you-sleep'
  It 'returns 0 if the power is AC'
    pmset() {
      print -r -- "Now drawing from 'AC Power'"
      print -r -- " -InternalBattery-0 (id=3997795)	100%; charged; 0:00 remaining present: true"
    }
    When call 'plug-it-now-or-i-will-get-you-sleep'
    The status should eq 0
  End
  It 'returns 1 if DUE is expired'
    pmset() {
      print 'Nope'
    }
    When call 'plug-it-now-or-i-will-get-you-sleep'
    The status should eq 1
  End
End

