" Vim syntax file
" Language:	CMakeCache
" Author:	Neui
" Version:	1.0.0

if exists("b:current_syntax")
	finish
endif
let b:current_syntax = "cmakecache"

syn match cmakecVarAdvanced contained '[^:]\{-}-ADVANCED\>'

syn keyword cmakecType contained
	\ STRING
	\ BOOL
	\ FILEPATH
	\ PATH
	\ STATIC
	\ UNINITIALIZED
	\ INTERNAL

syn match cmakecNumber '\d\+' contained
syn match cmakecString '.*' contained contains=cmakecVarRepl,cmakecListSep
syn region cmakecVarRepl start='<'ms=s+1 end='>'me=e-1 contained
	\ contains=cmakecVariable
syn match cmakecListSep ';' contained

syn keyword cmakecBool contained
	\ ON
	\ YES
	\ TRUE
	\ OFF
	\ NO
	\ FALSE
syn match cmakecBool contained '.\{-}-NOTFOUND$'

syn match cmakecVariable contained '[A-Za-z0-9_-]\+' contains=cmakecVarAdvanced
syn match cmakecStmtVariable '^[^:]\+' contains=cmakecVariable
	\ nextgroup=cmakecTypeSep
syn match cmakecTypeSep ':' contained nextgroup=cmakecStmtType
syn match cmakecType '' contained nextgroup=cmakecTypes
syn match cmakecStmtType '[^=]\+' contained contains=cmakecType
	\ nextgroup=cmakecValueSep
syn match cmakecValueSep '=' contained nextgroup=cmakecValue
syn match cmakecValue '' contained
	\ nextgroup=cmakecNumber,cmakecString,cmakecBool
	\  oneline display

syn match cmakecComment '^\s*#.*$' contains=@Spell
syn match cmakecDescription '^\s*\/\/.*$' contains=@Spell

hi def link cmakecComment     Comment
hi def link cmakecDescription Comment
hi def link cmakecVariable     Identifier
hi def link cmakecVarAdvanced  Special
hi def link cmakecType         Type
hi def link cmakecTypeSep  Delimiter
hi def link cmakecStmtType Error
hi def link cmakecValueSep Delimiter
hi def link cmakecValue    String
hi def link cmakecString   String
hi def link cmakecVarRepl  String
hi def link cmakecListSep  Delimiter
hi def link cmakecString   String
hi def link cmakecNumber   Number
hi def link cmakecBool     Boolean

