#compdef {{_input_:command}}

# vim: set ft=zsh:

# ==========================================================
# {{_name_}}
# {{_expr_:strftime('%c')}}
# based on {{_input_:command}} version {{_input_:version}}
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -LR zsh
setopt warn_create_global typeset_silent no_short_loops no_auto_pushd
setopt extended_glob      glob_dots      rc_quotes      hist_subst_pattern

local context curcontext=${curcontext} state line expl state_descr
integer ret=1
local -A opt_args val_args

# {{_cursor_}}

