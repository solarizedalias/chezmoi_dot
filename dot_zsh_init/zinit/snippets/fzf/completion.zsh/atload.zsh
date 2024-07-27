
typeset -ga FZF_CMD

FZF_CMD=(fzf)
FZF_COMPLETION_TRIGGER_FALLBACK=":::"
case "${TERM_PROGRAM}" in
  (tmux)
    FZF_CMD=(fzf-tmux -p 80%)
    FZF_COMPLETION_TRIGGER_FALLBACK=":::"
    ;;
  (*)
    FZF_CMD=(fzf)
    FZF_COMPLETION_TRIGGER_FALLBACK=":::"
    ;;
esac

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  local FD=fd
  [[ ${+commands[fdfind]} ]] && FD=fdfind
  ${FD} \
    --color=always \
    --hidden \
    --follow \
    --exclude=".git" \
    . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  local FD=fd
  [[ ${+commands[fdfind]} ]] && FD=fdfind
  ${FD} \
    --color=always \
    --type d \
    --hidden \
    --follow \
    --exclude=".git" \
    . "$1"
}

_fzf_complete_kill() {
  _fzf_complete \
    -m \
    --header-lines=1 \
    --preview="echo {}" \
    --preview-window=down:20:wrap:hidden \
    --min-height 20 \
    -- \
    "$@" < \
      =(
        grc --colour=on ps -e -o user,uid,pid,ppid,stime,tty,time,command
      )
}
_fzf_complete_kill_post() {
  awk '{print $3}'
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local COMMAND=$1
  shift

  local -a pargs extra_args
  case "${COMMAND}" in
    (cd|pushd|cdr)
      pargs=(
        eza
        --color=always
        -alhF
        --git
        --group-directories-first
        --git-ignore
        --tree
        --level=2
        --color-scale
        '{}'
      )
    ;;
    (export|unset)
      pargs=(
        typeset -p -- '{}'
      )
    ;;
    (ssh)
      pargs=( dig '{}' )
    ;;
    (kill)
      pargs=(
        'preview-ex.zsh process {3}'
      )
      extra_args=(
        --bind="ctrl-r:reload(grc --colour=on ps -e -o user,uid,pid,ppid,stime,tty,time,command)"
      )
    ;;
    (*)
      pargs=(
        '[[' -f '{}' ']]'
          '&&'
          preview.sh '{}' ';'

        '[[' -d '{}' ']]' '&&'
        eza
          '{}'
          --color=always
          -alhF
          --git
          --group-directories-first
          --git-ignore
          --tree
          --level=2
          --color-scale ';'
      )
    ;;
  esac
  command ${FZF_CMD[@]} "$@" --preview="${(j: :)pargs}" ${(@)extra_args}
}

export FZF_COMPLETION_TRIGGER="${FZF_COMPLETION_TRIGGER_FALLBACK}"
export FZF_COMPLETION_OPTS="--ansi --height=80% --preview-window=right:60%"
bindkey "^]^I" fzf-completion

