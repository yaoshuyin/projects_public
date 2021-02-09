**install**
```bash
apt install ctags
```

**usage**
```bash
 ctags -R --fields=+lS --sort=1 --exclude=.svn --exclude=asm* -f ~/.vim/tags .
```

```vim
  :set tags=~/.vim/tags
  :map <C-i> :!ctags -R --verbose --fields=+lS --sort=1 --exclude=.svn -f ~/.vim/tags .<Enter>
  
  C-]          跳转到 定义处
  C-t          跳回
  C-w }        预览窗口显示
  :pclose      关闭预览窗口
  
  <C-i>        给当前目录下生成tags
```
