 ```bash
 cat ~/.vim/bashrc 
   export TERM=xterm-<t_co>color
   
 grep '.vim/bashrc' ~/.bashrc || echo source ~/.vim/bashrc >> ~/.bashrc
```

```vim
call plug#begin('~/.vim/plugged')
   Plug 'itchyny/lightline.vim'
call plug#end()

"lightline
if !has('gui_running')
    set laststatus=2
    set t_co=256
endif
"~lightline
```vim
