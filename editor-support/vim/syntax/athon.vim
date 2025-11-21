" Vim syntax file
" Language: Athōn
" Maintainer: Athōn Language Team
" Latest Revision: 2024-11-20

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword athonKeyword fn let if else while for in match return break continue loop
syn keyword athonKeyword struct enum type trait impl pub cap region import

" Types
syn keyword athonType int bool string

" Constants
syn keyword athonBoolean true false

" Built-in functions
syn keyword athonBuiltin print abs min max pow sqrt mod
syn keyword athonBuiltin length concat compare array_length
syn keyword athonBuiltin file_read file_write file_append file_exists

" Comments
syn region athonLineComment start="//" end="$"
syn region athonBlockComment start="/\*" end="\*/"

" Strings
syn region athonString start='"' end='"' contains=athonEscape,athonPlaceholder
syn match athonEscape '\\.' contained
syn match athonPlaceholder '{}' contained

" Numbers
syn match athonNumber '\<\d\+\>'
syn match athonNumber '\<0x[0-9a-fA-F]\+\>'

" Operators
syn match athonOperator "+"
syn match athonOperator "-"
syn match athonOperator "\*"
syn match athonOperator "/"
syn match athonOperator "%"
syn match athonOperator "=="
syn match athonOperator "!="
syn match athonOperator "<"
syn match athonOperator ">"
syn match athonOperator "<="
syn match athonOperator ">="
syn match athonOperator "&&"
syn match athonOperator "||"
syn match athonOperator "!"
syn match athonOperator "="
syn match athonOperator "->"
syn match athonOperator "=>"
syn match athonOperator "\.\."
syn match athonOperator "\."
syn match athonOperator "::"

" Function definitions
syn match athonFunctionDef '\<fn\s\+\zs\w\+\>' contained
syn match athonFunctionKeyword '\<fn\>' nextgroup=athonFunctionDef skipwhite
syn match athonFunction '\<\w\+\>\s*('me=e-1

" Enum variants (Type::Variant)
syn match athonEnumVariant '\<[A-Z][a-zA-Z0-9_]*::[A-Z][a-zA-Z0-9_]*\>'

" Type names (capitalized)
syn match athonTypeName '\<[A-Z][a-zA-Z0-9_]*\>'

" Highlighting
hi def link athonKeyword Keyword
hi def link athonType Type
hi def link athonBoolean Boolean
hi def link athonBuiltin Function
hi def link athonLineComment Comment
hi def link athonBlockComment Comment
hi def link athonString String
hi def link athonEscape SpecialChar
hi def link athonPlaceholder SpecialChar
hi def link athonNumber Number
hi def link athonOperator Operator
hi def link athonFunction Function
hi def link athonFunctionDef Function
hi def link athonFunctionKeyword Keyword
hi def link athonEnumVariant Constant
hi def link athonTypeName Type

let b:current_syntax = "athon"
