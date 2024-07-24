
if exists('b:done_syntax_after_zsh') && b:done_syntax_after_zsh > 1
  finish
else
  let b:done_syntax_after_zsh = 0
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

function! s:clear_group_if_exists(...) abort
  for l:group in a:000
    if hlexists(l:group)
      execute 'syntax clear ' . l:group
    endif
  endfor
endfunction

call s:clear_group_if_exists('zshCharacterClass', 'zshParametersSetByShell', 'zshParametersUsedByShell')
syntax case match

syntax match      zshCharacterClass /:\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\|IDENT\|IFS\|IFSSPACE\|INCOMPLETE\|INVALID\|WORD\):/
      \ oneline
      \ containedin=ALL,zshRainbow_lv1_r1

syntax keyword    zshParametersSetByShell
      \ ARGC argv status pipestatus CPUTYPE EGID EUID ERRNO FUNCNEST GID HISTCMD LINENO LOGNAME MACHTYPE OLDPWD OPTARG OPTIND OSTYPE PPID PWD RANDOM SECONDS SHLVL signals
      \ TRY_BLOCK_ERROR TRY_BLOCK_INTERRUPT TTY TTYIDLE UID USERNAME VENDOR zsh_eval_context ZSH_EVAL_CONTEXT ZSH_ARGZERO ZSH_EXECUTION_STRING ZSH_NAME ZSH_PATCHLEVEL zsh_scheduled_events ZSH_SCRIPT ZSH_SUBSHELL ZSH_VERSION
      \ containedin=zshSubst,zshSubstString

syntax keyword    zshParametersUsedByShell
      \ ARGV0 BAUD cdpath CDPATH COLUMNS CORRECT_IGNORE CORRECT_IGNORE_FILE DIRSTACKSIZE ENV FCEDIT fignore FIGNORE fpath FPATH histchars HISTCHARS HISTFILE HISTORY_IGNORE HISTSIZE HOME IFS KEYBOARD_HACK KEYTIMEOUT
      \ LANG LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LC_NUMERIC LC_TIME LINES LISTMAX LOGCHECK MAIL MAILCHECK mailpath MAILPATH manpath MANPATH match mbegin mend MATCH MBEGIN MEND module_path MODULE_PATH NULLCMD
      \ path PATH POSTEDIT PROMPT PROMPT2 PROMPT3 PROMPT4 prompt PROMPT_EOL_MARK PS1 PS2 PS3 PS4 psvar PSVAR READNULLCMD REPORTMEMORY REPORTTIME REPLY reply RPROMPT RPS1 RPROMPT2 RPS2 SAVEHIST SPROMPT SPROMPT
      \ STTY TERM TERMINFO TERMINFO_DIRS TIMEFMT TMOUT TMPPREFIX TMPSUFFIX watch WATCH WATCHFMT WORDCHARS ZBEEP ZDOTDIR zle_bracketed_paste zle_highlight ZLE_LINE_ABORTED ZLE_REMOVE_SUFFIX_CHARS ZLE_SPACE_SUFFIX_CHARS
      \ ZLE_RPROMPT_INDENT
      \ containedin=zshSubst,zshSubstString

highlight default link zshCharacterClass Special
highlight default link zshParametersSetByShell Special
highlight default link zshParametersUsedByShell Special

let &cpoptions = s:cpo_save
unlet s:cpo_save
let b:done_syntax_after_zsh += 1

