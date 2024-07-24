#compdef {{_input_:command}}

# vim: set ft=zsh:

# ==========================================================
# {{_name_}}
# {{_expr_:strftime('%c')}}
# based on {{_input_:command}} version
# AUTHOR: solarizedalias
#
# ==========================================================

emulate -LR zsh
setopt extended_glob warn_create_global typeset_silent no_short_loops
setopt hist_subst_pattern no_auto_pushd rc_quotes

local context curcontext=${curcontext} state line expl state_descr
integer ret=1
local -A opt_args val_args

# {{_cursor_}}

