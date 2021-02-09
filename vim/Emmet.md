**install**
```vim
Plug 'mattn/emmet-vim'
```

**config**
```vim

```

**usage**
```vim
:Emmet html:5
  <!DOCTYPE html>
  <html lang="en">                                                 
  <head>
     <meta charset="UTF-8">                       
     <title></title>                         
  </head>                     
  <body>                        
                          
  </body>                            
  </html>
  
:Emmet table>tr>td
:Emmet ul>li>span
:Emmet span
:Emmet span*5   给出5次span
:Emmet 'div>p#foo$*3>a
     <div>                                                        
        <p id="foo1"><a href=""></a></p>                                                         
        <p id="foo2"><a href=""></a></p>                          
        <p id="foo3"><a href=""></a></p>                          
     </div>
```
