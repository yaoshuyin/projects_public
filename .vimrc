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

