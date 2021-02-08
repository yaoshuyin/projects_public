**install**
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**~/.vimrc**
```vim
call plug#begin('~/.vim/plugged') 
   Plug 'Valloric/YouCompleteMe'                                                                          
call plug#end()  
```
