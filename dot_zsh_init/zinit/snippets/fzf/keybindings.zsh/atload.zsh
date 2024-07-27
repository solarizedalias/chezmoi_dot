
emulate -LR zsh
setopt typeset_silent no_short_loops no_auto_pushd  warn_create_global
setopt extended_glob  glob_dots      rc_quotes      hist_subst_pattern
setopt noclobber      noappendcreate

export FZF_CTRL_T_COMMAND="fd -H --color=always --follow --exclude=.git"
export FZF_CTRL_T_OPTS="
  --height=80% --preview-window=right:60%
  --preview=\"
    [[ -d {} ]] && eza -alhF --group-directories-first --git --git-ignore --tree --level=2 --color-scale --color=always -- {} ;
    [[ -f {} ]] && ( highlight -O ansi -l -- {} 2>/dev/null || bat --color=always -- {} 2>/dev/null || file -- {} ) 2>/dev/null ;
  \"
"

# Preview context...
# I gave up.
# execute:FROM=\$\(( \$\{(Q):-{1}\} - 5 \)); TO=\$\(( \$\{(Q):-{1}\} + 5 \)); for i in seq \$FROM \$TO; do; echo \$history[\$i]; done
# hmm...

export FZF_CTRL_R_OPTS="
      --height=80%
      --preview=\"print -r -- {1} ; { get-history.zsh {1} || print -r -- {2..}; } | bat - --style numbers --language=zsh --color=always ; \"
      --preview-window=right:70%:wrap
      --bind=\"ctrl-space:toggle-preview,ctrl-v:replace-query\"
    "

bindkey "^R" fzf-history-widget
export FZF_ALT_C_COMMAND="fd -td --hidden --color=always --exclude=.git --exclude=.git_ --exclude=mackup"
export FZF_ALT_C_OPTS=" --height=80% --bind=\"ctrl-r:toggle-sort\"
      --preview=\"eza -alhF --group-directories-first --git --git-ignore --tree --level=2 --color-scale --color=always {} ; \"
      --preview-window=right:60%
    "

