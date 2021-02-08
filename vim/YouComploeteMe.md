filetype plugin on

call plug#begin('~/.vim/plugged')
   Plug 'Valloric/YouCompleteMe'
call plug#end()

"YouCompleteMe
let g:ycm_semantic_triggers =  {
  \   'c': ['->', '.'],
  \   'objc': ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \            're!\[.*\]\s'],
  \   'ocaml': ['.', '#'],
  \   'cpp,cuda,objcpp': ['->', '.', '::'],
  \   'perl': ['->'],
  \   'php': ['->', '::'],
  \   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': ['.'],
  \   'ruby,rust': ['.', '::'],
  \   'lua': ['.', ':'],
  \   'erlang': [':'],
  \ }

autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"~YouCompleteMe
