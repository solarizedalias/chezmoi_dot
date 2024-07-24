
if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" XXX SymbolDesc, SymbolSignature usually can only have a few kinds of
" keywords like proc/func/template/macro...
syntax keyword nimlspHoverNimKeywords contained
      \ addr and as asm
      \ bind block break
      \ case cast concept const continue converter
      \ defer discard distinct div do
      \ elif else end enum except export
      \ finally for from func
      \ if import in include interface is isnot iterator
      \ let
      \ macro method mixin mod
      \ nil not notin
      \ object of or out
      \ proc ptr
      \ raise ref return
      \ shl shr static
      \ template try tuple type
      \ using
      \ var
      \ when while
      \ xor
      \ yield


syntax keyword nimlspHoverCommonTypes contained
      \ int int8 int16 int32 int64 uint uint8 uint16 uint32 uint64
      \ float float32 float64
      \ char string cstring pointer typedesc ptr ref
      \ void auto any untyped typed bool
      \ SomeSighedInt SomeUnsignedInt
      \ SomeOrdinal BiggestInt SomeFloat SomeNumber Ordinal
      \ static type range array openArray openarray varargs seq set
      \ UncheckedArray sink lent HSlice Slice byte
      \ Natural Positive RootObj RootRef
      \ Exception Defect CatchableError JsRoot owned
      \ TaintedString ByteAddress BiggestFloat BiggestUInt
      \ clong culong cchar cschar cshort cint csize csize_t
      \ clonglong cfloat cdouble clongdouble cuchar cushort
      \ cstringArray BackwardsIndex NimNode ForLoopStmt
      \ File FileMode
      \ object
      \ Thread Channel Lock Cond
      \ NimNodeKind NimNodeKinds NimTypeKind NimTypeKinds NimSym LineInfo
      \ StaticParam
      \ Deque HeapQueue IntSet Option PackedSet SharedList SharedTable
      \ DoublyLinkedNodeObj DoublyLinkedNode SinglyLinkedNodeObj SinglyLinkedNode
      \ SinglyLinkedList DoublyLinkedList SinglyLinkedRing DoublyLinkedRing
      \ SomeLinkedList SomeLinkedRing SomeLinkedCollection SomeLinkedNode
      \ Table TableRef OrderedTable OrderedTableRef CountTable CountTableRef
      \ Hash JsonNodeKind JsonNode JsonNodeObj
      \ PegKind Peg

syntax keyword nimlspHoverCommonProcs contained
      \ $ echo debugEcho add pop dealloc quit del compiles declared move
      \ chr deepCopy =sink

syntax keyword nimlspHoverCommonMacros contained
      \ assert doAssert await async notin isnot alloc alloc0 realloc realloc0
      \ likely unlikely closureScope rangeCheck currentSourcePath newException

" By convention, let's assume `camelCase` to be genral ident, `PascalCase` to be types
syntax match nimlspHoverNimIdentLower /[a-z][0-9A-Za-z_]*/ contained
syntax match nimlspHoverNimIdentUpper /[A-Z][0-9A-Za-z_]*/ contained

" Include syntax definitions from user's runtime
silent! syntax include @Nim syntax/nim.vim

" Inlined Nim words in the text enclosed with backticks
syntax match nimlspHoverInline /``[^`]*``/
      \ contained
      \ contains=nimlspHoverInlined

syntax match nimlspHoverInlinedIgnore /<\S\+>/
      \ containedin=nimlspHoverInlined contained
      \ contains=NONE

syntax region nimlspHoverInline start=/`/ end=/`/
      \ contained
      \ contains=nimlspHoverInlined

syntax region nimlspHoverInlined start=/`\+\zs[^`#]/ end=/\ze`/
      \ contained
      \ contains=nimlspHoverNimKeywords,nimlspHoverCommonMacros,nimlspHoverCommonProcs,nimlspHoverCommonTypes,nimlspHoverNimIdentUpper,nimlspHoverNimIdentLower,@Nim
syntax match nimlspHoverInlined /`\zs[A-Za-z]\ze`/
      \ contains=nimlspHoverNimKeywords,nimlspHoverCommonMacros,nimlspHoverCommonProcs,nimlspHoverCommonTypes,nimlspHoverNimIdentUpper,nimlspHoverNimIdentLower,@Nim
      \ contained


" Qualified symbol name the doc is showing the text for.
" Appears once at the very beginning.
syntax match nimlspHoverSymbolDesc   /^\S\+\ze:\s/
      \ nextgroup=nimlspHoverSymbolSignature contains=@Nim,nimlspHoverNimKeywords

" Signature of type/proc/template/macro right after the qualified name
syntax region nimlspHoverSymbolSignature start=/./ end=/\n/
      \ oneline
      \ contained
      \ contains=nimlspHoverNimKeywords,nimlspHoverCommonMacros,nimlspHoverCommonProcs,nimlspHoverCommonTypes,nimlspHoverNimIdentUpper,nimlspHoverNimIdentLower,@Nim
      \ nextgroup=nimlspHoverText

" All the rest should be the text. Contains code blocks, inlined Nim words.
syntax region nimlspHoverText start=/\%>1l^/ end=/\%$/
      \ contains=nimlspHoverInline,nimlspHoverCodeBlock

" Code block written in Nim, embedded with rst syntax.
syntax region nimlspHoverCodeBlock start=/^\.\.\scode-block::\sNim\zs$/ end=/^\z1\@!/ contains=@Nim

highlight default link nimlspHoverInlinedIgnore  Comment
highlight default link nimlspHoverNimKeywords    Keyword


highlight default link nimlspHoverCommonTypes    Type
highlight default link nimlspHoverCommonProcs    Function
highlight default link nimlspHoverCommonMacros   Macro
highlight default link nimlspHoverNimIdentLower  Identifier
highlight default link nimlspHoverNimIdentUpper  Type

let b:current_syntax = 'nimlsp-hover'

