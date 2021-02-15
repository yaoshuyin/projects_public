**install**
```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

**CocInstall**
```bash
$ apt install python3 python3-pip python3-venv

$ unset http_proxy
$ unset https_proxy
 
$ curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
$ apt install -y nodejs
```

```vim
"bash
:CocInstall coc-sh

"php
:CocInstall coc-phpls

"json
:CocInstall coc-json
 
.python
:CocInstall coc-pyright

"html
:CocInstall coc-html

"js
:CocInstall coc-tsserver

"css
:CocInstall coc-css

"go
$ apt install golang
"$ go env -w GO111MODULE=on
"$ go env -w GOPROXY=https://goproxy.cn,direct" 
:CocInstall coc-go

"snippets
:CocInstall coc-snippets 

"c/c++
"$ apt install clangd
:CocInstall coc-clangd
 
```


