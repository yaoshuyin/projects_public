**install**
```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

**install new git**
```bash
apt remove git
apt install zlib1g zlib1g-dev libcurl4-openssl-dev
wget -c "https://www.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz"
tar xvf git-2.30.1.tar.gz 
cd git-2.30.1
./configure 
make
make install
ln -s /usr/local/bin/git /usr/bin/git
git clone https://github.com/powerline/fonts.git --depth=1
```

**CocInstall**
```bash
$ if ! which node
then
    node -v |grep v14 
    if [ $? -ne 0 ]
    then
         apt -y remove nodejs node
         curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - 
        apt -y update
        apt -y install nodejs npm
    fi
fi

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


