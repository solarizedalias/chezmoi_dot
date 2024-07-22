
() {

  # Aligned in accordance with my current config
  PS2='               🔜 %_ %F{cyan}❯❯%f '
  PS3='               🎮 %0_ %F{magenta}❯❯%f '

  # ZSH has a quirk where `preexec` is only run if a command is actually run (i.e
  # pressing ENTER at an empty command line will not cause preexec to fire). This
  # can cause timing issues, as a user who presses "ENTER" without running a command
  # will see the time to the start of the last command, which may be very large.

  # To fix this, we create STARSHIP_START_TIME upon preexec() firing, and destroy it
  # after drawing the prompt. This ensures that the timing for one command is only
  # ever drawn once (for the prompt immediately after it is run).

  zmodload zsh/parameter  # Needed to access jobstates variable for NUM_JOBS
  zmodload zsh/mathfunc
  zmodload zsh/datetime
  (( ${+functions[is-at-least]} )) || builtin autoload -Uz is-at-least

  starship_render() {
    emulate -L zsh
    setopt NO_sh_word_split

    local -a starship_prompt_segments prompt_segments

    builtin jobs &>/dev/null
    integer JOBS=${(%):-'%j'}
    starship_prompt_segments=(
      ${(f)"$(
        command starship prompt \
          --keymap="${KEYMAP-}" \
          --status=${STATUS:-0} \
          --cmd-duration=${STARSHIP_DURATION-} \
          --jobs="${JOBS:-0}"
      )"}
    )
    local LNHN='%F{blue}%B%h%b%f %(?.%F{green}.%F{red})%B'${STATUS:-0}'%b%f '
    prompt_segments=(
      ${starship_prompt_segments[1]}
      ${LNHN}${starship_prompt_segments[2]}
    )
    PROMPT=${(F)prompt_segments}
  }

  typeset -ig STARSHIP_CAPTURED_TIME
  if ! is-at-least 5; then
    __starship_get_time() {
        [[ -v STARSHIP_CAPTURED_TIME ]] || typeset -ig STARSHIP_CAPTURED_TIME
        STARSHIP_CAPTURED_TIME=$(command starship time)
    }
  else
    __starship_get_time() {
        [[ -v STARSHIP_CAPTURED_TIME ]] || typeset -ig STARSHIP_CAPTURED_TIME
        ((STARSHIP_CAPTURED_TIME = int(rint(EPOCHREALTIME * 1000))))
    }
  fi

  # Will be run before every prompt draw
  starship_precmd() {

    integer STATUS=$?
    # Compute cmd_duration, if we have a time to consume, otherwise clear the
    # previous duration

    if [[ -v STARSHIP_START_TIME ]]; then
        typeset -ig STARSHIP_END_TIME
      __starship_get_time && (( STARSHIP_END_TIME = STARSHIP_CAPTURED_TIME ))
        # STARSHIP_END_TIME=${$(( EPOCHREALTIME * 1000))%.*}
        typeset -ig STARSHIP_DURATION
        (( STARSHIP_DURATION = STARSHIP_END_TIME - STARSHIP_START_TIME ))
        unset STARSHIP_START_TIME
    else
        unset STARSHIP_DURATION
    fi

    # Render the updated prompt
    starship_render
  }

  starship_preexec() {
    typeset -ig STARSHIP_START_TIME
    __starship_get_time && (( STARSHIP_START_TIME = STARSHIP_CAPTURED_TIME ))
  }

  typeset -agU precmd_functions preexec_functions

  precmd_functions+=( starship_precmd )
  preexec_functions+=( starship_preexec )

  # Set up a function to redraw the prompt if the user switches vi modes
  starship_zle-keymap-select() {
    starship_render
    zle reset-prompt
  }

  ## Check for existing keymap-select widget.
  # zle-keymap-select is a special widget so it'll be "user:fnName" or nothing. Let's get fnName only.
  local existing_keymap_select_fn=${widgets[zle-keymap-select]#user:}
  if [[ -z ${existing_keymap_select_fn} ]]; then
    zle -N zle-keymap-select starship_zle-keymap-select
  else
    # Define a wrapper fn to call the original widget fn and then Starship's.
    starship_zle-keymap-select-wrapped() {
        ${existing_keymap_select_fn} "$@"
        starship_zle-keymap-select "$@"
    }

    zle -N zle-keymap-select starship_zle-keymap-select-wrapped
  fi

  typeset -ig STARSHIP_START_TIME
  __starship_get_time && (( STARSHIP_START_TIME = STARSHIP_CAPTURED_TIME ))
  export STARSHIP_SHELL="zsh"

  # Set up the session key that will be used to store logs
  # Random generates a number b/w 0 - 32767 and
  # Pad it to 16+ chars.
  # Trim to 16-digits if excess.
  export STARSHIP_SESSION_KEY
  STARSHIP_SESSION_KEY="${(l<16><0>):-${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}}"

}

