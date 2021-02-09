**install**
```bash
apt install ctags
```

**usage**
```bash
 ctags -R --fields=+lS --sort=1 --exclude=.svn --exclude=asm* -f ~/.vim/tags .
```

```vim
  set tags=~/.vim/tags
  
  C-]  跳转到 定义处
  c-t  跳回
```
