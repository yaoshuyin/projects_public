**install**
```bash
$ mkdir ~/.vim/plugin
$ cp /usr/share/vim/addons/plugin/matchit.vim ~/.vim/plugin/
```

**VIM内置插件,需自定义匹配(在标签上 按 % 即可跳转)**
```vim
let b:match_words='\<if\>:\<elif\>:\<else\>:\<elseif\>:\<fi\>,\<do\>:\<done\>,\<case\>:\<esac\>'
```
