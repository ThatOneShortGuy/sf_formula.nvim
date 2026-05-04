" Quit if syntax already loaded for this buffer
if exists("b:current_syntax")
  finish
endif

" --- Boolean literals ---
syn keyword sffBoolean True False TRUE FALSE
hi def link sffBoolean Boolean

" --- Null literal ---
syn case ignore
syn keyword sffNull null
syn case match
hi def link sffNull Constant

" --- Numbers ---
syn match sffNumber '\v\d+(\.\d*)?' contains=sffNumberDot
syn match sffNumberDot '\.' contained
hi def link sffNumber Number
hi def link sffNumberDot Number

" --- Operators ---
syn match sffOperator '\(==\|!=\|<>\|<=\|>=\|&&\||||\)'
syn match sffOperator "[-^*/+=<>&]"
hi def link sffOperator Operator

" --- Keyword ---
syn match sffKeyword '\([A-Za-z][A-Za-z0-9_]*\)'
hi def link sffKeyword Keyword

" --- Field references ---
" Highlight dotted references (Account.Owner.Name) and common custom-field names.
syn match sffFieldSeparator '\.' contained
syn match sffFieldReference '\v<[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+>' contains=sffFieldSeparator
syn match sffFieldReference '\v<[A-Za-z][A-Za-z0-9_]*__[cr]*>'
hi def link sffFieldReference Identifier
hi def link sffFieldSeparator Delimiter

" --- Strings ---
" Double and single quoted strings with escapes
syn match sffStringEscape +\v\\.+ contained
syn region sffString start=+"+ skip=+\v\\.+ end=+"+ contains=sffStringEscape
syn region sffString start=+'+ skip=+\v\\.+ end=+'+ contains=sffStringEscape
hi def link sffString String
hi def link sffStringEscape SpecialChar

" --- Block comments ---
syn region sffComment start="/\*" end="\*/" " contains=@Spell
hi def link sffComment Comment

" --- Function names ---
" Match known Salesforce formula functions when used as calls.
syn case ignore
syn match sffFunction '\v<(abs|addmonths|and|begins|blankvalue|br|case|casesafeid|ceiling|contains|currencyrate|date|datevalue|datetimevalue|day|distance|exp|find|floor|geolocation|getrecordids|getsessionid|hour|htmlencode|hyperlink|if|image|imageproxyurl|include|includes|isblank|ischanged|isclone|isnew|isnull|isnumber|ispickval|jsencode|jsinhtmlencode|junctionidlist|left|len|linkto|ln|log|lower|lpad|max|mceiling|mfloor|mid|millisecond|min|minute|mod|month|not|now|nullvalue|or|parentgroupval|predict|prevgroupval|priorvalue|regex|requirescript|reverse|right|round|rpad|second|sqrt|substitute|text|timenow|timevalue|today|trim|upper|urlencode|urlfor|value|vlookup|weekday|year)>\ze\s*\('
syn case match
hi def link sffFunction Function

" --- Delimeter ---
syn match sffDelimiter "[,.]"
hi def link sffDelimiter Delimiter

" --- TODO/FIXME inside comments ---
syn keyword sffTodo TODO FIXME XXX contained
hi def link sffTodo Todo
" Include it inside comments:
syn region sffComment start="/\*" end="\*/" contains=sffTodo

let b:current_syntax = "sff"
