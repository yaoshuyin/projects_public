set tabstop=4
set shiftwidth=4
set expandtab

set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936

"打开后光标到上次关闭时位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"修改vimdiff的背景色，以防看不清楚
if &diff
    set t_Co=128
    let g:solarized_diffmode="high"

    highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=60 gui=none guifg=bg guibg=Red
    highlight DiffDelete cterm=bold ctermfg=10 ctermbg=60 gui=none guifg=bg guibg=Red
    highlight DiffChange cterm=bold ctermfg=10 ctermbg=0 gui=none guifg=bg guibg=Red
    highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

endif
"~修改vimdiff的背景色，以防看不清楚


"按m移动当前行到文件尾,M移动当前行到文件尾
function MoveEnd()
   let l = line(".")
   :exe "normal ddGp"
   :cal cursor(l,0)
   ":exe "normal zz"
   :update
endfunction

function MoveToFirstLine()
   let l = line(".")
   :exe "normal dd0P"
   :cal cursor(l,0)
   ":exe "normal zz"
   :update
endfunction

noremap  m  :call MoveEnd()<Esc>
noremap  <s-m>  :call MoveEnd()<Esc>
"~移动当前行到文件尾


"复制选择内容并查询所有包含它或以它开头或结尾的行到文件尾部
function! MyVFunc(all)
   "复制,并获取选择内容
   normal! gvy
   normal! `<""y`>
   let x = @"
   "~复制,并获取选择内容

   "标记当前行号
   :let l = line(".")
     "执行移动命令
     :if a:all == "all"
       :exe ":g/".x."/m$"
     :elseif a:all == "head"
       :exe ":g/^".x."/m$"
     :elseif a:all == "tail"
       :exe ":g/".x."$/m$"
     :endif
   "返回当前行号
   :cal cursor(l,0)
endfunction
vmap <silent>  s :call MyVFunc("all")<CR>
vmap <silent>  t :call MyVFunc("head")<CR>
vmap <silent>  T :call MyVFunc("tail")<CR>
"~复制选择内容并查询所有包含它或以它开头或结尾的行到文件尾部

"default
"my set

"syntax=
syntax on

"showmode
set showmode

"showcmd
set showcmd

"mouse= 
set mouse=a

"backspace=indent,eol,start
backspace=indent,eol,start

"载入与类型对应的缩进规则,编辑.py文件会载入缩进规则~/.vim/indent/python.vim
filetype indent on

"noautoindent
"按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致 
set autoindent


"tabstop=8
set tabstop=4
set softtabstop=4

"shiftwidth=8
"按下>>、<< 或者 == 时，每一级缩进的字符数
set shiftwidth=4

"noexpandtab
"由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格
"softtabstop=0
"Tab 转为多少个空格
set expandtab
set softtabstop=4

"nonumber
"显示行号
set number

"nocursorline
"光标所在的当前行高亮
set cursorline

"textwidth=0 
"设置行宽，即一行显示多少个字符
set textwidth=80

"wrap
"自动折行，即太长的行分成几行显示
set wrap

"nolinebreak 
"不会在单词内部折行,只有遇到指定的符号(比如空格、连词号和其他标点符号),才发生折行
set linebreak

"wrapmargin
"指定折行处与编辑窗口的右边缘之间空出的字符数


"laststatus=1
"是否显示状态栏, 0 表示不显示, 1 表示只在多窗口时显示, 2 表示显示
set laststatus=2

"ruler
"在状态栏显示光标的当前位置（位于哪一行哪一列)
set  ruler


"noshowmatch
"光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号
set showmatch

"spelllang=en
打开英语单词的拼写检查
set spell spelllang=en_us

"noundofile
"保留撤销历史。
"操作记录只在本次编辑时有效，文件关闭，操作历史就消失了
"undofile可以在文件关闭后，操作记录保留在一个文件里面，继续存在
"撤消文件是跟原文件保存在一起的隐藏文件，文件名以.un~开头
set undofile


"设置备份文件、交换文件、操作历史文件的保存位置
"结尾的//文件名带有绝对路径，用%替换目录分隔符，以防止文件重名
set backupdir=~/.vim/.backup//  
set directory=~/.vim/.swp//
set undodir=~/.vim/.undo//

"noautochdir
"自动切换工作目
set autochdir

"noerrorbells
"出错时,不要发出响声
set noerrorbells

"novisualbell
"出错时，发出视觉提示，通常是屏幕闪烁
set visualbell

"history=200
"Vim 需要记住多少次历史操作
set history=1000

