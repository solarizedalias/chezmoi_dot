
---@alias rpc_fun fun(channel: number, method, ...)
---@alias timer_callback fun(): boolean
---@alias log_level '0'|'1'|'2'|'3'|'4'
---@alias paste_phase '-1' | '1' | '2' | '3'

---@class VIM
---@field api API
---@field version fun(): VERSION
---@field in_fast_event fun(): boolean
---@field NIL vim.NIL
---@field empty_dict fun(): table
---@field rpcnotify rpc_fun
---@field rpcrequest rpc_fun
---@field stricmp fun(a: string, b: string): '0'|'1'|'-1'
---@field str_utfindex fun(str: string, index: number): number, number
---@field str_byteindex fun(str: string, index: number, use_utf16?: boolean): number
---@field schedule fun(callback: fun())
---@field defer_fn fun(fn: fun(), timeout: number): TIMER
---@field wait fun(time: number, callback?: timer_callback, interval?: number, fastonly?: boolean): boolean, '-1'|'-2'|nil
---@field type_idx 'true'
---@field val_idx  'false'
---@field types TYPES
---
---@field call fun(func: string, ...): any
---@field cmd  fun(cmd: string)
---@field fn FN
---
---@field g table<string, any>
---@field b table<string, any>
---@field w table<string, any>
---@field t table<string, any>
---@field v V
---@field env table<string, string>
---
---@field opt OPT
---@field opt_local OPT
---@field opt_global OPT
---@field o OPT
---@field go OPT
---@field bo OPT
---@field wo OPT
---
---@field inspect fun(object: any, options: INSPECT_OPT): string
---@field notify fun(msg: string, log_level: log_level, opts: NOTIFY_OPT)
---@field on_key fun(fn: fun(), ns_id?: number): number
---@field paste fun(lines: string[], phase: paste_phase): boolean



---@class API
---@class VERSION
---@class vim.NIL
---@class TIMER
---@class TYPES
---@class FN
---@class V
---@class OPT
---
---@class INSPECT_OPT
---@class NOTIFY_OPT

(function(...) return ... end)(vim)

---@type VIM
local v
(function(...) return ... end)(v.notify)

