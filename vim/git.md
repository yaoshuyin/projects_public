```bash
Ubuntu:
  apt remove git
  apt install zlib1g zlib1g-dev libcurl4-openssl-dev gcc make tcl gettext

CentOS:
  yum install zlib zlib-devel.x86_64 gcc make tcl gettext curl libcurl-devel

wget -c "https://www.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz"
tar xvf git-2.30.1.tar.gz 
cd git-2.30.1
./configure 
make
make install

ln -s /usr/local/bin/git /usr/bin/git

git clone https://github.com/powerline/fonts.git --depth=1
```

**使用vimdiff来比较**
```bash
git config --global diff.tool vimdiff
git config --global difftool.prompt No

git diff a.php
git difftool a.php
```

**ssh clone**
```bash
$ git clone ssh://user@132.33.19.168:22/data/gitroot/Spiders
user@132.33.19.168's password: xxxxxx

$ git add .

$ git commit -m "xxx"

$ git push
user@132.33.19.168's password: xxxxxx

$ git pull
user@132.33.19.168's password: xxxxxx

```
