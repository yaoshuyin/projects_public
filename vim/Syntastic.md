```vim
call plug#begin('~/.vim/plugged')
   Plug 'vim-syntastic/syntastic'
call plug#end()


"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"pip install vim-vint
let g:syntastic_vim_checkers = ['vint']

"npm install -g eslint eslint_d
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
let g:syntastic_vue_eslint_exec = 'eslint_d'
let g:syntastic_vue_checkers = ['eslint']

let g:syntastic_html_checkers = ['eslint']
let g:syntastic_html_eslint_exec = 'eslint_d'

"npm install -g jsonlint
let g:syntastic_json_checkers = ['jsonlint']

"npm install -g csslint
let g:syntastic_css_checkers = ['csslint']

"npm install -g dockerfile_lint
let g:syntastic_Dockerfile_checkers = ['dockerfile_lint']
"apt install ruby
"gem install mdl
let g:syntastic_md_checkers = ['mdl']

"lua自带
let g:syntastic_lua_checkers = ['luac']
"python自带
let g:syntastic_python_checkers = ['pylint']

"apt install  shellcheck
"yum install ShellCheck
let g:syntastic_sh_checkers = ['shellcheck']
"pip install sqlint
let g:syntastic_sql_checkers = ['sqlint']
"pip install yamllint
let g:syntastic_yaml_checkers = ['yamllint']

```
