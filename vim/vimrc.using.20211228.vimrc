"安装NerdHack字体
"1) export http_proxy=http://127.0.0.1:8889
"   export https_proxy=http://127.0.0.1:8889
"   mkdir -p ~/.local/share/fonts/NerdFonts
"   cd .local/share/fonts/NerdFonts
"   wget -c https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
"   unzip Hack.zip
"   fc-cache -vf .
"   fc-list
"
"2)!!!重要的一步
"  终端->编辑->配置文件->Default->字体 -> Hack Nerd Font Regular

set encoding=UTF-8
let g:WebDevIconsNerdTreeGitPluginForceVAlign=1

augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :CocCommand explorer
augroup END

"..........git...............
nmap ga :Git add .<CR>
nmap gc :Git commit<CR>
nmap gp :Git push<CR>
nmap gl :Git log<CR>
nmap gu :Git pull<CR>
nmap gs :Git show<CR>
"..........~git...............


".........................key skills...........................
".补全
" Shift-Tab   自动补全
"
".........................key skills...........................

"安装 coc-pyright 而不是coc-python(有错误)
"apt install ruby-dev
"gem install neovim

"apt install python2.7
"apt install python2.7-dev
"pip install neovim
"pip install --user --upgrade pynvim

"pip3 install neovim
"pip3 install --user --upgrade pynvim

"CocJava
"$ apt install openjdk-11-jdk
":CocInstall coc-java
"$ wget -c https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz
"$ cd ~/.config/coc/extensions/coc-java-data/server
"$ tar xvf jdt-language-server-0.57.0-202006172108.tar.gz
"$ vim mvnw  (在springboot根目录下)
"  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/


let g:python3_host_prog='/usr/bin/python3'
"![avatar](imgs/vimide.png)
"
"```vim
":Git log %
":Git add %
":Git commit -m "xxx" %
":Git push
"
"<F5> \ga  git add
"<F6> \gc  git commit
"<F7> \gp  git push
"     \gl  git log
"```
"
"**makrdown**
"```vim
"\pp   clipboard's image to pic/xxx.png, add ![avatar](pic/xxx.png)
"```
"
"**Key Bindings**
"```
" <F2>           Save file
" <F3>           打开关闭DefxTree
" <F4>/<C-c>     关闭buffer
" gt                             切换打开的窗口
" 鼠标双击/<cr>                  打开关闭目录/打开文件
" 鼠标双击/<cr>/<Left>/<Right>   打开关闭目录
"
" h              切换到上一层目录
" D              切换光标下目录为工作区顶级目录
"
" n              创建新文件
" N              创建新目录
" d              删除文件
" r              重命名文件
" m              移动文件
" c              复制文件
" p              粘贴文件
" .              隐藏文件切换
" ~              返回$HOME目录
" <Space>        切换选择与非选择状态
" *              切换所有选择与非选择状态
" j              向下移动光标
" k              向上移动光标
" <c-g>          显示全路径
"```
"**install vim8.2**
"```console
" $ setfacl -R -m d:u:tom:rwx /root
" $ setfacl -R -m u:tom:--- /root/.ssh
"
" $ apt-get install software-properties-common
" $ add-apt-repository ppa:jonathonf/vim
" $ apt update
" $ apt upgrade
" $ apt install python3-pip
" $ ln -s /usr/bin/pip3 /usr/bin/pip
" $ pip install pynvim
"```
"
"**install and ln nvim to vim**
"```console
"apt-get install software-properties-common
"apt-add-repository ppa:neovim-ppa/stable
"apt update
"apt install neovim
"mkdir ~/.config/nvim
"touch ~/.vimrc
"ln ~/.vimrc ~/.config/nvim/init.vim
"
"cat >> ~/.bashrc <<EOF
"alias vim="/usr/bin/nvim"
"alias vi="/usr/bin/nvim"
"alias oldvim="/usr/bin/vim"
"EOF
". ~/.bashrc
"```
"
"**install Plug**
"```console
"#vim & nvim :
"  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
"```
"
"**:CocInstall (after .vimrc & plug coc installed)**
"```vim
"$ apt install python3 python3-pip python3-venv
"
"$ curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
"$ apt install -y nodejs
"
"bash
":CocInstall coc-sh
"
"php
":CocInstall coc-phpls
"
"html
":CocInstall coc-html
"
"c/c++
"$ apt install clangd
":CocInstall coc-clangd
"
"python
":CocInstall coc-pyright
"
"css
":CocInstall coc-css
"
"go
"$ apt install golang
"$ go env -w GO111MODULE=on
"$ go env -w GOPROXY=https://goproxy.cn,direct
":CocInstall coc-go
"
"json
":CocInstall coc-json
"
"snippets
":CocInstall coc-snippets
"```
"
"**.vimrc**
"```vim
set encoding=utf-8
set mouse=a
"折叠处，鼠标双击切换折叠
noremap <2-LeftMouse> za
set hidden

"highlight current line
"set cursorline

"tabexpand
"""""""""""""""""tab"""""""""""""""""""
"缩进
set cindent smartindent
set tabstop=3 shiftwidth=3 softtabstop=-1

"tab转成空格
set expandtab
func MyExpandtab()
  if &modifiable == 1
     retab
  endif
endfunc
augroup AuExpandtab
  :autocmd BufEnter * :call MyExpandtab()
augroup END
"""""""""""""""""~tab"""""""""""""""""""

"terminal
set splitbelow
"nmap t :terminal<CR>
"~terminal

"save
nmap <F2> :w<CR>
imap <F2> <Esc>:w<CR>a

"..........Git key bindings...........
" <F5> \ga  git add
" <F6> \gc  git commit
" <F7> \gp  git push
"      \gl  git log

"nmap <silent> <F5>       :Git add %<CR>
nmap <silent> <Leader>ga :Git add %<CR>

nmap <silent> <F6>       :call MyGitCommit()<CR>
nmap <silent> <Leader>gc :call MyGitCommit()<CR>

nmap <silent> <F7>       :echo 'pushing...'<CR>:Git push<CR>
nmap <silent> <Leader>gp :echo 'pushing...'<CR>:Git push<CR>

nmap <silent> <Leader>gl :Git log %<CR>

function! MyGitCommit()
  let l:msg = input('Commit Msg: ')
  :execute 'Git commit -m "'.l:msg.'" %'
endfunction
"..........~Git key bindings...........

"vim command line press tab completion list
set wildmenu

set cmdheight=2
set updatetime=300
set shortmess+=c

"通过yy复制后，内容vim与系统可共用
set clipboard=unnamedplus,unnamed

"打开后光标到上次关闭时位置
augroup lastpos
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END
"~打开后光标到上次关闭时位置

"mkdir -p  ~/.vim/plugin
"cp /usr/share/vim/addons/plugin/matchit.vim ~/.vim/plugin/
let b:match_words='\<if\>:\<elif\>:\<else\>:\<elseif\>:\<fi\>,\<do\>:\<done\>,\<case\>:\<esac\>'

"..................... plugins ......................
"vim& nvim :
"  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')
   "符号自动高亮匹配
   Plug 'luochen1990/rainbow'

   "airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
   "~airline

   "git
   Plug 'tpope/vim-fugitive'
   Plug 'airblade/vim-gitgutter'
   Plug 'junegunn/gv.vim'
   "~git

   Plug 'ap/vim-css-color'

   "Plug 'vim-scripts/AutoComplPop'
   Plug 'hrsh7th/vim-vsnip'
   Plug 'hrsh7th/vim-vsnip-integ'

   "others
   Plug 'majutsushi/tagbar'
   Plug 'vim-scripts/txt.vim'
   Plug 'mattn/emmet-vim'
   Plug 'stephpy/vim-yaml'
   Plug 'ekalinin/Dockerfile.vim'
   Plug 'othree/html5.vim'
   Plug 'chrisbra/unicode.vim'

   "markdown
   "apt install xclip
   Plug 'godlygeek/tabular'
   Plug 'plasticboy/vim-markdown'
   Plug 'ferrine/md-img-paste.vim'
   "~markdown

   "apt install python3-pip; ln -s /usr/bin/pip3 /usr/bin/pip
   "pip install pynvim
   if has('nvim')
       Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
   else
       Plug 'Shougo/defx.nvim'
       Plug 'roxma/nvim-yarp'
       Plug 'roxma/vim-hug-neovim-rpc'
       Plug 'kristijanhusak/defx-icons'
       Plug 'kristijanhusak/defx-git'
   endif

   Plug 'liuchengxu/vista.vim'  " tagbar 超集替代品
   Plug 'neoclide/coc.nvim', {'branch': 'release'}
   "Plug 'vim-syntastic/syntastic'
   Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

   "snap install shfmt
   Plug 'Chiel92/vim-autoformat'
  Plug 'skywind3000/vim-quickui'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'yuki-yano/fern-preview.vim'
  Plug 'lambdalisue/fern-mapping-git.vim'
  Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  "apt install ctags
  Plug 'SirVer/ultisnips'
  Plug 'vim-scripts/taglist.vim'
  Plug 'honza/vim-snippets'
  Plug 'powerline/powerline'

  Plug 'ryanoasis/vim-devicons'
call plug#end()

"...................coc............................
"CocUninstall coc-spell-checker
":CocConfig (或编辑~/.config/nvim/coc-settings.json)
" {
"   "java.configuration.runtimes": [
"      {
"         "name": "JavaSE-11",
"         "path": "/usr/lib/jvm/java-11-openjdk-amd64/"
"      }
"   ],
"   "java.home": "/usr/lib/jvm/java-11-openjdk-amd64",
"   "java.configuration.maven.userSettings": "/root/.m2/wrapper/dists/apache-maven-3.8.3-bin/5a6n1u8or3307vo2u2jgmkhm0t/apache-maven-3.8.3/conf/settings.xml",
"   "java.import.maven.enabled": true,
"   "java.format.enabled": true,
"   "java.format.comments.enabled": true,
"   "java.format.onType.enabled": true,
"   "java.maven.updateSnapshots": true,
"   "java.maven.downloadSources": false,
"   "java.codeGeneration.useBlocks": false,
"   "java.codeGeneration.generateComments": true,
"   "java.codeGeneration.toString.template": "${object.className} [${member.name()}=${member.value}, ${otherMembers}]",
"   "java.codeGeneration.toString.listArrayContents": true,
"   "java.import.exclusions": [
"      "**/node_modules/**",
"      "**/.metadata/**",
"      "**/archetype-resources/**",
"      "**/META-INF/maven/**"
"   ],
"   "java.completion.importOrder": [
"      "java",
"      "javax",
"      "com",
"      "org"
"   ],
"   "java.saveActions.organizeImports": true,
"   "java.completion.enabled": true,
"   "java.completion.favoriteStaticMembers": [
"      "org.junit.Assert.*",
"      "org.junit.Assume.*",
"      "org.junit.jupiter.api.Assertions.*",
"      "org.junit.jupiter.api.Assumptions.*",
"      "org.junit.jupiter.api.DynamicContainer.*",
"      "org.junit.jupiter.api.DynamicTest.*",
"      "org.mockito.Mockito.*",
"      "org.mockito.ArgumentMatchers.*",
"      "org.mockito.Answers.*"
"   ],
"   "java.completion.guessMethodArguments": true,
"coc.preferences.extensionUpdateCheck": "daily",
"    "coc.preferences.messageLevel": "error",
"     "diagnostic.errorSign": "\uf467",
"     "diagnostic.warningSign": "\uf071",
"     "diagnostic.infoSign": "\uf129",
"     "diagnostic.hintSign": "\uf864",
"     "suggest.completionItemKindLabels": {
"         "class": "\uf0e8",
"         "color": "\ue22b",
"         "constant": "\uf8fe",
"         "default": "\uf29c",
"         "enum": "\uf435",
"         "enumMember": "\uf02b",
"         "event": "\ufacd",
"         "field": "\uf93d",
"         "file": "\uf723",
"         "folder": "\uf115",
"         "function": "\u0192",
"         "interface": "\uf417",
"         "keyword": "\uf1de",
"         "method": "\uf6a6",
"         "module": "\uf40d",
"         "operator": "\uf915",
"         "property": "\ue624",
"         "reference": "\ufa46",
"         "snippet": "\ue60b",
"         "struct": "\ufb44",
"         "text": "\ue612",
"         "typeParameter": "\uf728",
"         "unit": "\uf475",
"         "value": "\uf89f",
"         "variable": "\ue71b"
"     },
"     "codeLens.enable": true,
"     "diagnostic.checkCurrentLine": true,
"     "diagnostic.virtualTextPrefix": " ‚ùØ‚ùØ‚ùØ ",
"     "diagnostic.virtualText": true,
"     "coc.preferences.formatOnSaveFiletypes": [
"         "json",
"         "sh",
"         "python",
"         "c",
"         "cpp"
"     ]
" }
"
let g:coc_global_extensions = [
         \ 'coc-yank',
         \ 'coc-word',
         \ 'coc-webview',
         \ 'coc-vimlsp',
         \ 'coc-translator',
         \ 'coc-tag',
         \ 'coc-tabnine',
         \ 'coc-syntax',
         \ 'coc-stylelintplus',
         \ 'coc-snippets',
         \ 'coc-pairs',
         \ 'coc-omni',
         \ 'coc-neosnippet',
         \ 'coc-lists',
         \ 'coc-html-css-support',
         \ 'coc-html',
         \ 'coc-highlight',
         \ 'coc-git',
         \ 'coc-fzf-preview',
         \ 'coc-explorer',
         \ 'coc-eslint',
         \ 'coc-emoji',
         \ 'coc-emmet',
         \ 'coc-dictionary',
         \ 'coc-calc',
         \ 'coc-browser',
         \ 'coc-yaml',
         \ 'coc-xml',
         \ 'coc-vetur',
         \ 'coc-tsserver',
         \ 'coc-sumneko-lua',
         \ 'coc-sqlfluff',
         \ 'coc-sql',
         \ 'coc-sh',
         \ 'coc-python',
         \ 'coc-pyright',
         \ 'coc-pydocstring',
         \ 'coc-phpls',
         \ 'coc-markdownlint',
         \ 'coc-markdown-preview-enhanced',
         \ 'coc-json',
         \ 'coc-jedi',
         \ 'coc-java',
         \ 'coc-htmlhint',
         \ 'coc-gocode',
         \ 'coc-flow',
         \ 'coc-css'
     \ ]


  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  "按Shift-Tab进行补全
  inoremap <silent><expr> <S-TAB>  pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
  "inoremap <silent><expr><C-S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . ' ' . expand('<cword>')
    endif
  endfunction

  nmap <silent> K :call <SID>show_documentation()<CR>

  nmap <leader>rn <Plug>(coc-rename)

  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  nmap <leader>ac  <Plug>(coc-codeaction)
  nmap <leader>qf  <Plug>(coc-fix-current)

  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nmap <silent><nowait><expr> <leader><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : '\<C-f>'
    nmap <silent><nowait><expr> <leader><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : '\<C-b>'
    inoremap <silent><nowait><expr> <leader><C-f> coc#float#has_scroll() ? '\<c-r>=coc#float#scroll(1)\<cr>' : '\<Right>'
    inoremap <silent><nowait><expr> <leader><C-b> coc#float#has_scroll() ? '\<c-r>=coc#float#scroll(0)\<cr>' : '\<Left>'
    vnoremap <silent><nowait><expr> <leader><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : '\<C-f>'
    vnoremap <silent><nowait><expr> <leader><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : '\<C-b>'
  endif

  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  command! -nargs=0 Format :call CocAction('format')

  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
  set statusline^=%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}

  nmap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  nmap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  nmap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  nmap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  nmap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  nmap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  nmap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  nmap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  "scroll popup window
  nmap <expr> <c-d> Misc_popup_scroll_cursor_popup(1) ? '<esc>' : '<c-d>'
  nmap <expr> <c-u> Misc_popup_scroll_cursor_popup(0) ? '<esc>' : '<c-u>'

  function! Misc_popup_find_cursor_popup(...)
    let radius = get(a:000, 0, 2)
    let srow = screenrow()
    let scol = screencol()

    " it's necessary to test entire rect, as some popup might be quite small
    for r in range(srow - radius, srow + radius)
      for c in range(scol - radius, scol + radius)
        let winid = popup_locate(r, c)
        if winid != 0
          return winid
        endif
      endfor
    endfor

    return 0
  endfunction

  function! Misc_popup_scroll_cursor_popup(down)
    let winid = Misc_popup_find_cursor_popup()
    if winid == 0
      return 0
    endif

    let pp = popup_getpos(winid)
    call popup_setoptions( winid,
          \ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )

    return 1
  endfunction
  "~scroll popup window
"~...................coc............................


"..................syntaastic.......................
"Syntastic
":llist :lfirst :lnext :lprev :llast
" ,   go to the next msg
" ,,  go to the prev msg

 set statusline+=%#warningmsg#
 set statusline+=%{SyntasticStatuslineFlag()}
 set statusline+=%*

 let g:syntastic_always_populate_loc_list = 1
 let g:syntastic_aggregate_errors = 1
 let g:syntastic_auto_loc_list = 1
 let g:syntastic_loc_list_height = 6
 let g:syntastic_check_on_open = 1
 let g:syntastic_check_on_wq = 0
 let g:syntastic_quiet_messages = { 'type': 'style' }
 "设置error和warning的标志
 let g:syntastic_enable_signs = 1
 let g:syntastic_error_symbol='✗'
 let g:syntastic_warning_symbol='►'

 "禁用syntastic的文件类型
 let g:syntastic_disable_filetypes = ['java']

 "pip install vim-vint
 let g:syntastic_vim_checkers = ['vint']

 "npm install -g jsonlint
 let g:syntastic_json_checkers = ['jsonlint']

 "apt install ruby
 "gem install mdl for markdown
 let g:syntastic_md_checkers = ['mdl']

 "apt install  shellcheck
 "yum install ShellCheck
 let g:syntastic_sh_checkers = ['shellcheck']

 "npm install -g dockerfile_lint
 let g:syntastic_Dockerfile_checkers = ['dockerfile_lint']

 "python自带
 let g:syntastic_python_checkers = ['pylint']

 "yum install yamllint
 "pip install yamllint
 "apt install yamllint
 let g:syntastic_yaml_checkers = ['yamllint']

 "...........其它...................
 "npm install -g eslint eslint_d
 let g:syntastic_javascript_checkers = ['eslint']
 let g:syntastic_javascript_eslint_exec = 'eslint_d'
 let g:syntastic_vue_eslint_exec = 'eslint_d'
 let g:syntastic_vue_checkers = ['eslint']

 let g:syntastic_html_checkers = ['eslint']
 let g:syntastic_html_eslint_exec = 'eslint_d'

 "npm install -g csslint
 let g:syntastic_css_checkers = ['csslint']

 "lua自带
 let g:syntastic_lua_checkers = ['luac']

 "pip install sqlint
 let g:syntastic_sql_checkers = ['sqlint']

".......... keymap ................
" ,  the next msg
" ,, the prev msg
function! <SID>LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

function! <SID>LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction

nnoremap <silent> <Plug>LocationPrevious    :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext        :<C-u>exe 'call <SID>LocationNext()'<CR>
nmap <silent> ,,   <Plug>LocationPrevious
nmap <silent> ,    <Plug>LocationNext
".......... ~keymap ................


"......................airline.....................
  "let g:airline_powerline_fonts = 1
  if !exists('g:airline_symbols')
     let g:airline_symbols = {}
  endif

  "unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.linenr = '☰'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.maxlinenr = '㏑'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.spell = 'Ꞩ'
  let g:airline_symbols.notexists = 'Ɇ'
  let g:airline_symbols.whitespace = 'Ξ'

  let g:airline#extensions#tabline#enabled = 2
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline#extensions#tabline#formatter = 'default'
  let g:airline_theme='lucius'
  let g:airline_powerline_fonts = 1
  let g:airline_minimalist_showmod = 1


"......................~airline.....................

"rainbow
let g:rainbow_active = 1
   let g:rainbow_conf = {
   \  'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
   \  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
   \  'operators': '_,_',
   \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
   \  'separately': {
   \     '*': {},
   \     'tex': {
   \        'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
   \     },
   \     'lisp': {
   \        'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
   \     },
   \     'vim': {
   \        'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
   \     },
   \     'html': {
   \        'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
   \     },
   \     'css': 0,
   \  }
   \}
"~rainbow

"...............defx...................
" <F3>           打开关闭DefxTree
" <F4>/<C-c>     关闭buffer
" gt                             切换打开的窗口
" 鼠标双击/<cr>                  打开关闭目录/打开文件
" 鼠标双击/<cr>/<Left>/<Right>   打开关闭目录
"
" h              切换到上一层目录
" D              切换光标下目录为工作区顶级目录
"
" n              创建新文件
" N              创建新目录
" d              删除文件
" r              重命名文件
" m              移动文件
" c              复制文件
" p              粘贴文件
" .              隐藏文件切换
" ~              返回$HOME目录
" <Space>        切换选择与非选择状态
" *              切换所有选择与非选择状态
" j              向下移动光标
" k              向上移动光标
" <c-g>          显示全路径

map <C-C> :Bclose<CR>
map <F4>  :Bclose<CR>
map <F3>  :Defx<CR>
augroup Audefx
  autocmd FileType defx call s:defx_my_settings()
augroup END

function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'),
        \ '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
let g:defx_config_sid = s:SID_PREFIX()

call defx#custom#option('_', {
      \ 'winwidth': 20,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'defxtree',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })

call defx#custom#option('open', {
      \ 'winwidth': 20,
      \ 'split': 'vsplit',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': 'defxtree',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('filename', {
      \ 'min_width': 40,
      \ 'max_width': 40,
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })


function! s:defx_my_settings() abort
   nmap <silent>               gt      :bn<cr>

   nmap <silent><buffer><expr> h       defx#do_action('call', g:defx_config_sid . 'DefxSmartH')
   nmap <silent><buffer><expr> <Left>  defx#do_action('call', g:defx_config_sid . 'DefxSmartL')

   nmap <silent><buffer><expr> <Right> defx#do_action('call', g:defx_config_sid . 'DefxSmartR')
   nmap <silent><buffer><expr> o       defx#do_action('call', g:defx_config_sid . 'DefxSmartOpen')

   nmap <silent><buffer><expr> <2-LeftMouse> defx#is_directory() ?
       \ (defx#is_opened_tree() ? defx#do_action('close_tree') : defx#do_action('open_tree') ):
       \ defx#do_action('drop')

   nmap <silent><buffer><expr> <CR>  defx#do_action('call', g:defx_config_sid . 'DefxSmartOpen')
   nmap <silent><buffer><expr> <S-D> defx#do_action('call', g:defx_config_sid . 'DefxSmartChangeDir')

   nmap <silent><buffer><expr> .     defx#do_action('toggle_ignored_files')

   nmap <silent><buffer><expr> n     defx#do_action('new_file')
   nmap <silent><buffer><expr> N     defx#do_action('new_directory')
   nmap <silent><buffer><expr> r     defx#do_action('rename')
   nmap <silent><buffer><expr> d     defx#do_action('remove')

   nmap <silent><buffer><expr> m     defx#do_action('move')
   nmap <silent><buffer><expr> c     defx#do_action('copy')
   nmap <silent><buffer><expr> p     defx#do_action('paste')

   nmap <silent><buffer><expr> ~     defx#do_action('cd')
   nmap <silent><buffer><expr> yy    defx#do_action('yank_path')

   nmap <silent><buffer><expr> j     line('.') == line('$') ? 'gg' : 'j'
   nmap <silent><buffer><expr> k     line('.') == 1 ? 'G' : 'k'

   nmap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
   nmap <silent><buffer><expr> *     defx#do_action('toggle_select_all')
   nmap <silent><buffer><expr> <C-g> defx#do_action('print')

   nmap <silent><buffer><expr> s     defx#do_action('toggle_sort', 'time')
   nmap <silent><buffer><expr> E     defx#do_action('open', 'vsplit')
   nmap <silent><buffer><expr> ;     defx#do_action('repeat')
   nmap <silent><buffer><expr> C
     \ defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
endfunction

scriptencoding utf-8
 function! s:DefxSmartOpen(_)
   if defx#is_directory()
     call defx#call_action('open_tree')
     normal! j
   else
     let filepath = defx#get_candidate()['action__path']
     if tabpagewinnr(tabpagenr(), '$') >= 3
       if exists(':ChooseWin') == 2
         ChooseWin
       else
         let input = input('ChooseWin No./Cancel(n): ')
         if input ==# 'n' | return | endif
         if input == winnr() | return | endif
         exec input . 'wincmd w'
       endif
       exec 'e' filepath
     else
       exec 'wincmd w'
       exec 'e' filepath
     endif
   endif
 endfunction

 function! s:DefxSmartR(_)
   if defx#is_directory()
     call defx#call_action('open_tree')
     "normal! j
   endif
 endfunction

  function! s:DefxSmartL(_)
   if defx#is_directory()
     call defx#call_action('open_tree')
   endif
 endfunction

 function! s:DefxSmartChangeDir(_)
   let s:candidate = defx#get_candidate()
   let s:parent = fnamemodify(s:candidate['action__path'], s:candidate['is_directory'] ? ':p:h' : ':p:h')
   return defx#call_action('cd', s:parent)
 endfunction

 function! s:DefxSmartH(_)
   if line('.') ==# 1 || line('$') ==# 1
     return defx#call_action('cd', ['..'])
   endif

   if defx#is_opened_tree()
     return defx#call_action('close_tree')
   endif

   let s:candidate = defx#get_candidate()
   let s:parent = fnamemodify(s:candidate['action__path'], s:candidate['is_directory'] ? ':p:h:h' : ':p:h')
   let sep = '/'
   if s:trim_right(s:parent, sep) == s:trim_right(b:defx.paths[0], sep)
     return defx#call_action('cd', ['..'])
   endif

   call defx#call_action('search', s:parent)

   call defx#call_action('close_tree')
 endfunction
"...............~defx...................

".........save clipboard's image..........
"\pp to save clipboard's image into pic/xxx.png, and insert
"![avatar](pic/xxx.png)
let g:mdip_imgdir = 'pic'
let g:mdip_imgname = 'image'
augroup AuMarkdown
  autocmd FileType markdown nnoremap <silent> <Leader>pp :call mdip#MarkdownClipboardImage()<CR>avatar
augroup END
".........~save clipboard's image..........
"
"透明
"set statusline=%1*\%<%.50F\                 "显示文件名和文件路径 (%<应该可以去掉)
"set statusline+=%=%2*\%y%m%r%h%w\ %*        "显示文件类型及文件状态
"set statusline+=%3*\%{&ff}\[%{&fenc}]\ %*   "显示文件编码类型
"set statusline+=%4*\ row:%l/%L,col:%c\ %*   "显示光标所在行和列
"set statusline+=%5*\%3p%%\%*                "显示光标前文本所占总文本的比例

"markdown
let g:vim_markdown_folding_disabled = 1

"latstatus
"set laststatus=1

"F5 执行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
   exec 'w'
   if &filetype ==? 'c'
      exec '!g++ % -o %<'
      exec '!time ./%<'
   elseif &filetype ==? 'cpp'
      exec '!g++ % -o %<'
      exec '!time ./%<'
   elseif &filetype ==? 'java'
      exec '!javac %'
      exec '!time java %<'
   elseif &filetype ==? 'sh'
      :!time bash %
   elseif &filetype ==? 'python'
      exec '!time python3 %'
   elseif &filetype ==? 'html'
      exec '!firefox % &'
   elseif &filetype ==? 'go'
      exec '!go build %<'
      exec '!time go run %'
   elseif &filetype ==? 'mkd'
      exec '!~/.vim/markdown.pl % > %.html &'
      exec '!firefox %.html &'
   endif
endfunc
"~F5 执行
"```
if &diff
   syntax off
endif

"!!!保存前删除空格
function BeforeSave()
   :%s/\s\+$//e "delete the whitespaces end of the line
endfunction

augroup AuBeforeSave
  autocmd BufWritePre *  :call BeforeSave()
augroup END
"~!!!保存前删除空格

"!!!set title
"/**
" * Copyright (C) 2021 All rights reserved.
" *
" * FileName      : a.c
" * Author        : tomyao
" * Email         : tomyao@tom.com
" * Date          : 2021年11月16日
" * Description   :
" */
func AddTime()
    let l:lnum = searchpos('^\s*\*\?#\?\s\+Date\s\+:')[0]
    if lnum > 0
      call setline(lnum,substitute(getline(line('.')),'\s*$',strftime(' %Y%m%dT%H%M'),'g'))
   endif
endfunc

augroup AuSetTitle
  autocmd BufNewFile *.c,*.go,*.php exec ':call SetTitle()'
    func SetTitle()
         if expand('%:e') ==? 'php'
           call setline(1,'<?php')
           call append(line('.'),    '/**')
           let lnum=1
        else
           call setline(1,           '/**')
           let lnum=0
        endif

        call append(line('.')+lnum,   ' * Copyright (C) '.strftime('%Y').' All rights reserved.')
        call append(line('.')+lnum+1, ' *')
        call append(line('.')+lnum+2, ' * FileName      : '.expand('%:t'))
        call append(line('.')+lnum+3, ' * Author        : tomyao <tomyao@tom.com>')
        call append(line('.')+lnum+4, ' * Date          : ')
        call append(line('.')+lnum+5, ' * Description   : ')
        call append(line('.')+lnum+6, ' */')
        call append(line('.')+7,      '')
        call append(line('.')+8,      '')
    endfunc

"#!/bin/bash
"# Copyright (C) 2021 All rights reserved.
"#
"# FileName      : b.sh
"# Author        : tomyao
"# Email         : tomyao@tom.com
"# Date          : 2021年11月16日
"# Description   :
  autocmd BufNewFile *.sh,*.py exec ':call SetTitleBash()'
    func SetTitleBash()
       if expand('%:e') ==? 'sh'
        call setline(1,          '#!/bin/bash')
     else
        call setline(1,          '#!/usr/bin/python3')
     endif
        call append(line('.'),   '# Copyright (C) '.strftime('%Y').' All rights reserved.')
        call append(line('.')+1, '#')
        call append(line('.')+2, '# FileName      : '.expand('%:t'))
        call append(line('.')+3, '# Author        : tomyao <tomyao@tom.com>')
        call append(line('.')+4, '# Date          : ')
        call append(line('.')+5, '# Description   : ')
        call append(line('.')+6, '')
        call append(line('.')+7, '')
    endfunc

  autocmd BufNewFile * normal G

  autocmd BufWritePre *.c,*.go,*.php,*.sh,*.py :call AddTime()
augroup END
"~!!!set title

".....................flattened theme................................
" 'flattened_light.vim' -- Vim color scheme.
" Maintainer:   Romain Lafourcade (romainlafourcade@gmail.com)
" Description:  Light Solarized, without the bullshit.

hi clear

syntax enable
if exists('syntax_on')
  syntax reset
endif

let colors_name = 'flattened_light'

if (has('termguicolors'))
 set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
"!!!很重要，很清新
set background=light
set cursorline
hi  CursorLine  ctermbg=230    ctermfg=none cterm=NONE "cterm=NONE 很重要，如果没有它则下面会显示下线，很难看
"
"autocmd FileType * hi CocHintFloat   ctermbg=red   ctermfg=white
"
"autocmd FileType * hi CocErrorSign   ctermbg=red   ctermfg=white
"autocmd FileType * hi CocErrorFloat  ctermbg=red   ctermfg=white
"
"autocmd FileType * hi CocInfoSign    ctermfg=blue
"autocmd FileType * hi CocInfoFloat   ctermfg=white ctermbg=blue
"
"autocmd FileType * hi CocWarningSign ctermfg=white ctermbg=yellow
"
"autocmd FileType * hi FgCocErrorFloatBgCocFloating ctermfg=white ctermbg=darkred
"~!!!很重要，很清新


 set background=light
 hi Normal                                  cterm=NONE  ctermfg=11  ctermbg=15  guifg=#657b83  guibg=#fdf6e3  gui=NONE
 ""guifg控制提示窗口的!!!前景!!!和下拉菜单的文字!!!背景!!!
 hi Pmenu                                   cterm=reverse  ctermfg=white  ctermbg=grey  guifg=#eeeeee  guibg=grey  gui=reverse
 hi PmenuSbar                               cterm=reverse  ctermfg=0  ctermbg=11  guifg=#93a1a1 guibg=#657b83  gui=reverse
 hi PmenuSel                                cterm=reverse  ctermfg=14  ctermbg=0  guifg=#93a1a1  guibg=#073642  gui=reverse
 hi PmenuThumb                              cterm=reverse  ctermfg=11  ctermbg=15  guifg=#657b83  guibg=#fdf6e3  gui=reverse

 "注释色
 hi Comment                                 cterm=NONE  ctermfg=14 guifg=#93a1a1  gui=italic

 "光标所在行
 hi Cursor                                  cterm=NONE  ctermfg=15 ctermbg=11  guifg=#fdf6e3  guibg=#657b83  gui=NONE
 hi CursorLine                              cterm=NONE  ctermbg=7  guibg=#eee8d5  guisp=#586e75  gui=NONE
 hi CursorLineNr                            cterm=NONE  ctermfg=130  gui=NONE  guifg=Brown
 hi CursorColumn                            cterm=NONE  ctermbg=7  guibg=#eee8d5  gui=NONE

 hi Error                                   cterm=NONE  ctermfg=1  ctermbg=NONE  guifg=#dc322f  guibg=#fdf6e3  gui=NONE
 hi ErrorMsg                                cterm=reverse  ctermfg=1  ctermbg=NONE guifg=#dc322f  guibg=NONE gui=reverse

 "hi ColorColumn                             cterm=NONE  ctermbg=7  guibg=#eee8d5  gui=NONE
 "hi ConId                                   cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
 "hi Conceal                                 cterm=NONE  ctermfg=4  ctermbg=15  guifg=#268bd2  guibg=#fdf6e3  gui=NONE
 "hi PreProc                                 cterm=NONE  ctermfg=9  guifg=red guibg=#eeeeee  gui=NONE

 "控制标题
 hi Title                                   cterm=NONE  ctermfg=9  guifg=#b58900 guibg=#ffffff gui=NONE
 "控制搜索与quickfix
 hi Search                                  cterm=reverse  ctermfg=3  ctermbg=NONE  guifg=#b58900  guibg=NONE gui=reverse
 "控制quickfix
 hi LineNr                                  cterm=NONE  ctermfg=14  ctermbg=7  guifg=#93a1a1  guibg=#eee8d5  gui=NONE

 "............Diff............
 "控制差异
 hi DiffChange                              cterm=NONE  ctermfg=3  ctermbg=7  gui=NONE  guifg=#000000  guibg=lightred  guisp=#b58900  gui=NONE
 "差异处字符前景色,红字，粗体，白底
 hi DiffText                                cterm=bold  ctermfg=4  ctermbg=7  gui=NONE  guifg=red  guibg=#ffffff  guisp=#268bd2  gui=bold

 "比对面多出行的色
 hi DiffAdd                                 cterm=NONE  ctermfg=2  ctermbg=7  gui=NONE  guifg=#719e07  guibg=lightcyan  guisp=#719e07  gui=NONE
 "比对面缺少的行的色
 hi DiffDelete                              cterm=NONE  ctermfg=1  ctermbg=7  gui=NONE  guifg=#dc322f  guibg=#eee8d5  gui=NONE
 "..........~Diff.............

 "控制变量与标识符号前景色
 hi Identifier                              cterm=NONE  ctermfg=4  guifg=#268bd2 guibg=NONE gui=NONE "
 hi Constant                                cterm=NONE  ctermfg=6  guifg=#b58900  guibg=#ffffff gui=NONE


"hi Directory                               cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi FoldColumn                              cterm=NONE  ctermfg=11  ctermbg=7  guifg=#657b83  guibg=#eee8d5  gui=NONE
"hi Folded                                  cterm=NONE,underline  ctermfg=11  ctermbg=7  guifg=#657b83  guibg=#eee8d5  guisp=#fdf6e3  gui=NONE
"hi HelpExample                             cterm=NONE  ctermfg=10  guifg=#586e75  gui=NONE
"hi IncSearch                               cterm=standout  ctermfg=9  gui=standout  guifg=#cb4b16
"hi MatchParen                              cterm=NONE  ctermfg=1  ctermbg=14  gui=NONE  guifg=#dc322f  guibg=#93a1a1  gui=NONE
"hi ModeMsg                                 cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi MoreMsg                                 cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi NonText                                 cterm=NONE  ctermfg=12  gui=NONE  guifg=#839496  gui=NONE
"hi Question                                cterm=NONE  ctermfg=6  gui=NONE  guifg=#2aa198  gui=NONE
"hi SignColumn                              cterm=NONE  ctermfg=11  ctermbg=NONE  guifg=#657b83  guibg=NONE  gui=NONE
"hi Special                                 cterm=NONE  ctermfg=1  guifg=#dc322f  gui=NONE
"hi SpecialKey                              cterm=NONE  ctermfg=12  ctermbg=7  gui=NONE  guifg=#839496  guibg=#eee8d5  gui=NONE
"hi SpellBad                                cterm=undercurl ctermfg=NONE  ctermbg=NONE  gui=undercurl  guisp=#dc322f
"hi SpellCap                                cterm=undercurl  ctermfg=NONE  ctermbg=NONE  gui=undercurl  guisp=#6c71c4
"hi SpellLocal                              cterm=undercurl  ctermfg=NONE  ctermbg=NONE  gui=undercurl  guisp=#b58900
"hi SpellRare                               cterm=undercurl  ctermfg=NONE  ctermbg=NONE  gui=undercurl  guisp=#2aa198
"hi Statement                               cterm=NONE  ctermfg=2  guifg=#719e07 guibg=#eeeeee gui=NONE
"hi StatusLine                              cterm=reverse  ctermfg=10  ctermbg=7  gui=reverse  guifg=#586e75  guibg=#eee8d5  guibg=NONE
"hi StatusLineNC                            cterm=reverse  ctermfg=12  ctermbg=7  gui=reverse  guifg=#839496  guibg=#eee8d5  guibg=NONE
"hi TabLine                                 cterm=underline  ctermfg=11  ctermbg=7  gui=underline  guifg=#657b83  guibg=#eee8d5  guisp=#657b83
"hi TabLineFill                             cterm=underline  ctermfg=11  ctermbg=7  gui=underline  guifg=#657b83  guibg=#eee8d5  guisp=#657b83
"hi TabLineSel                              cterm=underline,reverse  ctermfg=14  ctermbg=0  gui=underline,reverse  guifg=#93a1a1  guibg=#073642  guisp=#657b83
""guifg 控制title的背景色,guibg 控制title的前景色
"hi Todo                                    cterm=bold  ctermfg=5  ctermbg=15  guifg=#d33682  guibg=NONE gui=bold
"hi Type                                    cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi Underlined                              cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi VarId                                   cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi VertSplit                               cterm=NONE  ctermfg=12  ctermbg=12  guifg=#839496  guibg=#839496  gui=NONE
"hi Visual                                  cterm=reverse  ctermfg=14  ctermbg=15 gui=reverse  guifg=#93a1a1  guibg=#fdf6e3  guibg=NONE
"hi VisualNOS                               cterm=reverse  ctermbg=7 gui=reverse  guibg=#eee8d5  guibg=NONE
"hi WarningMsg                              cterm=NONE  ctermfg=9  gui=NONE  guifg=#dc322f  gui=NONE
"hi WildMenu                                cterm=reverse  ctermfg=0  ctermbg=7  guifg=#073642  guibg=#eee8d5  gui=reverse
"hi cPreCondit                              cterm=NONE  ctermfg=9  guifg=#cb4b16  gui=NONE
"hi gitcommitBranch                         cterm=NONE  ctermfg=5  gui=NONE  guifg=#d33682  gui=NONE
"hi gitcommitComment                        cterm=NONE  ctermfg=14  gui=italic  guifg=#93a1a1  gui=NONE
"hi gitcommitDiscardedFile                  cterm=NONE  ctermfg=1  gui=NONE  guifg=#dc322f  gui=NONE
"hi gitcommitDiscardedType                  cterm=NONE  ctermfg=1  guifg=#dc322f  gui=NONE
"hi gitcommitFile                           cterm=NONE  ctermfg=11  gui=NONE  guifg=#657b83  gui=NONE
"hi gitcommitHeader                         cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi gitcommitOnBranch                       cterm=NONE  ctermfg=14  gui=NONE  guifg=#93a1a1  gui=NONE
"hi gitcommitSelectedFile                   cterm=NONE  ctermfg=2  gui=NONE  guifg=#719e07  gui=NONE
"hi gitcommitSelectedType                   cterm=NONE  ctermfg=2  guifg=#719e07  gui=NONE
"hi gitcommitUnmerged                       cterm=NONE  ctermfg=2  gui=NONE  guifg=#719e07  gui=NONE
"hi gitcommitUnmergedFile                   cterm=NONE  ctermfg=3  gui=NONE  guifg=#b58900  gui=NONE
"hi gitcommitUntrackedFile                  cterm=NONE  ctermfg=6  gui=NONE  guifg=#2aa198  gui=NONE
"hi helpHyperTextEntry                      cterm=NONE  ctermfg=2  guifg=#719e07  gui=NONE
"hi helpHyperTextJump                       cterm=underline  ctermfg=4  gui=underline  guifg=#268bd2
"hi helpNote                                cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi helpOption                              cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi helpVim                                 cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi hsImport                                cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi hsImportLabel                           cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hsModuleName                            cterm=underline  ctermfg=2  gui=underline  guifg=#719e07
"hi hsNiceOperator                          cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hsStatement                             cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hsString                                cterm=NONE  ctermfg=12  guifg=#839496  gui=NONE
"hi hsStructure                             cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hsType                                  cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi hsTypedef                               cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hsVarSym                                cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi hs_DeclareFunction                      cterm=NONE  ctermfg=9  guifg=#cb4b16  gui=NONE
"hi hs_OpFunctionName                       cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi hs_hlFunctionName                       cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi htmlArg                                 cterm=NONE  ctermfg=12  guifg=#839496  gui=NONE
"hi htmlEndTag                              cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi htmlSpecialTagName                      cterm=NONE  ctermfg=4  gui=italic  guifg=#268bd2  gui=NONE
"hi htmlTag                                 cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi htmlTagN                                cterm=NONE  ctermfg=10  gui=NONE  guifg=#586e75  gui=NONE
"hi htmlTagName                             cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi javaScript                              cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi pandocBlockQuote                        cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocBlockQuoteLeader1                 cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocBlockQuoteLeader2                 cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE
"hi pandocBlockQuoteLeader3                 cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi pandocBlockQuoteLeader4                 cterm=NONE  ctermfg=1  guifg=#dc322f  gui=NONE
"hi pandocBlockQuoteLeader5                 cterm=NONE  ctermfg=11  guifg=#657b83  gui=NONE
"hi pandocBlockQuoteLeader6                 cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi pandocCitation                          cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi pandocCitationDelim                     cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi pandocCitationID                        cterm=underline  ctermfg=5  gui=underline  guifg=#d33682
"hi pandocCitationRef                       cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi pandocComment                           cterm=NONE  ctermfg=14  gui=italic  guifg=#93a1a1  gui=NONE
"hi pandocDefinitionBlock                   cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocDefinitionIndctr                  cterm=NONE  ctermfg=13  gui=NONE  guifg=#6c71c4  gui=NONE
"hi pandocDefinitionTerm                    cterm=standout  ctermfg=13  gui=standout  guifg=#6c71c4
"hi pandocEmphasis                          cterm=NONE  ctermfg=11  gui=italic  guifg=#657b83  gui=NONE
"hi pandocEmphasisDefinition                cterm=NONE  ctermfg=13  gui=italic  guifg=#6c71c4  gui=NONE
"hi pandocEmphasisHeading                   cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocEmphasisNested                    cterm=NONE  ctermfg=11  gui=NONE  guifg=#657b83  gui=NONE
"hi pandocEmphasisNestedDefinition          cterm=NONE  ctermfg=13  gui=NONE  guifg=#6c71c4  gui=NONE
"hi pandocEmphasisNestedHeading             cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocEmphasisNestedTable               cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocEmphasisTable                     cterm=NONE  ctermfg=4  gui=italic  guifg=#268bd2  gui=NONE
"hi pandocEscapePair                        cterm=NONE  ctermfg=1  gui=NONE  guifg=#dc322f  gui=NONE
"hi pandocFootnote                          cterm=NONE  ctermfg=2  guifg=#719e07  gui=NONE
"hi pandocFootnoteDefLink                   cterm=NONE  ctermfg=2  gui=NONE  guifg=#719e07  gui=NONE
"hi pandocFootnoteInline                    cterm=NONE,underline  ctermfg=2  gui=NONE,underline  guifg=#719e07  gui=NONE
"hi pandocFootnoteLink                      cterm=underline  ctermfg=2  gui=underline  guifg=#719e07
"hi pandocHeading                           cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocHeadingMarker                     cterm=NONE  ctermfg=3  gui=NONE  guifg=#b58900  gui=NONE
"hi pandocImageCaption                      cterm=NONE,underline  ctermfg=13  gui=NONE,underline  guifg=#6c71c4  gui=NONE
"hi pandocLinkDefinition                    cterm=underline  ctermfg=6  gui=underline  guifg=#2aa198  guisp=#839496
"hi pandocLinkDefinitionID                  cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocLinkDelim                         cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi pandocLinkLabel                         cterm=underline  ctermfg=4  gui=underline  guifg=#268bd2
"hi pandocLinkText                          cterm=NONE,underline  ctermfg=4  gui=NONE,underline  guifg=#268bd2  gui=NONE
"hi pandocLinkTitle                         cterm=underline  ctermfg=12  gui=underline  guifg=#839496
"hi pandocLinkTitleDelim                    cterm=underline  ctermfg=14  gui=underline  guifg=#93a1a1  guisp=#839496
"hi pandocLinkURL                           cterm=underline  ctermfg=12  gui=underline  guifg=#839496
"hi pandocListMarker                        cterm=NONE  ctermfg=5  guifg=#d33682  gui=NONE
"hi pandocListReference                     cterm=underline  ctermfg=5  gui=underline  guifg=#d33682
"hi pandocMetadata                          cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocMetadataDelim                     cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi pandocMetadataKey                       cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocNonBreakingSpace                  cterm=reverse  ctermfg=1  ctermbg=NONE  gui=reverse  guifg=#dc322f  guibg=NONE
"hi pandocRule                              cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocRuleLine                          cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocStrikeout                         cterm=reverse  ctermfg=14  ctermbg=NONE  gui=reverse  guifg=#93a1a1  guibg=NONE
"hi pandocStrikeoutDefinition               cterm=reverse  ctermfg=13  ctermbg=NONE  gui=reverse  guifg=#6c71c4  guibg=NONE
"hi pandocStrikeoutHeading                  cterm=reverse  ctermfg=9  ctermbg=NONE  gui=reverse  guifg=#cb4b16  guibg=NONE
"hi pandocStrikeoutTable                    cterm=reverse  ctermfg=4  ctermbg=NONE  gui=reverse  guifg=#268bd2  guibg=NONE
"hi pandocStrongEmphasis                    cterm=NONE  ctermfg=11  gui=NONE  guifg=#657b83  gui=NONE
"hi pandocStrongEmphasisDefinition          cterm=NONE  ctermfg=13  gui=NONE  guifg=#6c71c4  gui=NONE
"hi pandocStrongEmphasisEmphasis            cterm=NONE  ctermfg=11  gui=NONE  guifg=#657b83  gui=NONE
"hi pandocStrongEmphasisEmphasisDefinition  cterm=NONE  ctermfg=13  gui=NONE  guifg=#6c71c4  gui=NONE
"hi pandocStrongEmphasisEmphasisHeading     cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocStrongEmphasisEmphasisTable       cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocStrongEmphasisHeading             cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocStrongEmphasisNested              cterm=NONE  ctermfg=11  gui=NONE  guifg=#657b83  gui=NONE
"hi pandocStrongEmphasisNestedDefinition    cterm=NONE  ctermfg=13  gui=NONE  guifg=#6c71c4  gui=NONE
"hi pandocStrongEmphasisNestedHeading       cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocStrongEmphasisNestedTable         cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocStrongEmphasisTable               cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocStyleDelim                        cterm=NONE  ctermfg=14  guifg=#93a1a1  gui=NONE
"hi pandocSubscript                         cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocSubscriptDefinition               cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocSubscriptHeading                  cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocSubscriptTable                    cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocSuperscript                       cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocSuperscriptDefinition             cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocSuperscriptHeading                cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocSuperscriptTable                  cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocTable                             cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocTableStructure                    cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocTableZebraDark                    cterm=NONE  ctermfg=4  ctermbg=7  guifg=#268bd2  guibg=#eee8d5  gui=NONE
"hi pandocTableZebraLight                   cterm=NONE  ctermfg=4  ctermbg=15  guifg=#268bd2  guibg=#fdf6e3  gui=NONE
"hi pandocTitleBlock                        cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi pandocTitleBlockTitle                   cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocTitleComment                      cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi pandocVerbatimBlock                     cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi pandocVerbatimInline                    cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi pandocVerbatimInlineDefinition          cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi pandocVerbatimInlineHeading             cterm=NONE  ctermfg=9  gui=NONE  guifg=#cb4b16  gui=NONE
"hi pandocVerbatimInlineTable               cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi perlHereDoc                             cterm=NONE  ctermfg=10  ctermbg=15  guifg=#586e75  guibg=#fdf6e3  gui=NONE
"hi perlStatementFileDesc                   cterm=NONE  ctermfg=6  ctermbg=15  guifg=#2aa198  guibg=#fdf6e3  gui=NONE
"hi perlVarPlain                            cterm=NONE  ctermfg=3  ctermbg=15  guifg=#b58900  guibg=#fdf6e3  gui=NONE
"hi rubyDefine                              cterm=NONE  ctermfg=10  ctermbg=15  gui=NONE  guifg=#586e75  guibg=#fdf6e3  gui=NONE
"hi texMathMatcher                          cterm=NONE  ctermfg=3  ctermbg=15  guifg=#b58900  guibg=#fdf6e3  gui=NONE
"hi texMathZoneX                            cterm=NONE  ctermfg=3  ctermbg=15  guifg=#b58900  guibg=#fdf6e3  gui=NONE
"hi texRefLabel                             cterm=NONE  ctermfg=3  ctermbg=15  guifg=#b58900  guibg=#fdf6e3  gui=NONE
"hi texStatement                            cterm=NONE  ctermfg=6  ctermbg=15  guifg=#2aa198  guibg=#fdf6e3  gui=NONE
"hi vimCmdSep                               cterm=NONE  ctermfg=4  gui=NONE  guifg=#268bd2  gui=NONE
"hi vimCommand                              cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi vimCommentString                        cterm=NONE  ctermfg=13  guifg=#6c71c4  gui=NONE
"hi vimGroup                                cterm=NONE,underline  ctermfg=4  gui=NONE,underline  guifg=#268bd2  gui=NONE
"hi vimHiGroup                              cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi vimHiLink                               cterm=NONE  ctermfg=4  guifg=#268bd2  gui=NONE
"hi vimIsCommand                            cterm=NONE  ctermfg=12  guifg=#839496  gui=NONE
"hi vimSynMtchOpt                           cterm=NONE  ctermfg=3  guifg=#b58900  gui=NONE
"hi vimSynType                              cterm=NONE  ctermfg=6  guifg=#2aa198  gui=NONE

"hi link Boolean                    Constant
"hi link Character                  Constant
"hi link Conditional                Statement
"hi link Debug                      Special
"hi link Define                     PreProc
"hi link Delimiter                  Special
"hi link Exception                  Statement
"hi link Float                      Number
"hi link Function                   Identifier
"hi link HelpCommand                Statement
"hi link Include                    PreProc
"hi link Keyword                    Statement
"hi link Label                      Statement
"hi link Macro                      PreProc
"hi link Number                     Constant
"hi link Operator                   Statement
"hi link PreCondit                  PreProc
"hi link Repeat                     Statement
"hi link SpecialChar                Special
"hi link SpecialComment             Special
"hi link StorageClass               Type
"hi link String                     Constant
"hi link Structure                  Type
"hi link SyntasticError             SpellBad
"hi link SyntasticErrorSign         Error
"hi link SyntasticStyleErrorLine    SyntasticErrorLine
"hi link SyntasticStyleErrorSign    SyntasticErrorSign
"hi link SyntasticStyleWarningLine  SyntasticWarningLine
"hi link SyntasticStyleWarningSign  SyntasticWarningSign
"hi link SyntasticWarning           SpellCap
"hi link SyntasticWarningSign       Todo
"hi link Tag                        Special
"hi link Typedef                    Type
"
"hi link diffAdded                  Statement
"hi link diffBDiffer                WarningMsg
"hi link diffCommon                 WarningMsg
"hi link diffDiffer                 WarningMsg
"hi link diffIdentical              WarningMsg
"hi link diffIsA                    WarningMsg
"hi link diffLine                   Identifier
"hi link diffNoEOL                  WarningMsg
"hi link diffOnly                   WarningMsg
"hi link diffRemoved                WarningMsg
"
"hi link gitcommitDiscarded         gitcommitComment
"hi link gitcommitDiscardedArrow    gitcommitDiscardedFile
"hi link gitcommitNoBranch          gitcommitBranch
"hi link gitcommitSelected          gitcommitComment
"hi link gitcommitSelectedArrow     gitcommitSelectedFile
"hi link gitcommitUnmergedArrow     gitcommitUnmergedFile
"hi link gitcommitUntracked         gitcommitComment
"
"hi link helpSpecial                Special
"
"hi link hsDelimTypeExport          Delimiter
"hi link hsImportParams             Delimiter
"hi link hsModuleStartLabel         hsStructure
"hi link hsModuleWhereLabel         hsModuleStartLabel
"hi link htmlLink                   Function
"
"hi link lCursor                    Cursor
"
"hi link pandocCodeBlock            pandocVerbatimBlock
"hi link pandocCodeBlockDelim       pandocVerbatimBlock
"hi link pandocEscapedCharacter     pandocEscapePair
"hi link pandocLineBreak            pandocEscapePair
"hi link pandocMetadataTitle        pandocMetadata
"hi link pandocTableStructureEnd    pandocTableStructre
"hi link pandocTableStructureTop    pandocTableStructre
"hi link pandocVerbatimBlockDeep    pandocVerbatimBlock
"
"hi link vimFunc                    Function
"hi link vimSet                     Normal
"hi link vimSetEqual                Normal
"hi link vimUserFunc                Function
"hi link vipmVar                    Identifier

hi clear SyntasticErrorLine
hi clear SyntasticWarningLine
hi clear helpLeadBlank
hi clear helpNormal
hi clear pandocTableStructre

if has('nvim')
  let g:terminal_color_0  = '#eee8d5'
  let g:terminal_color_1  = '#dc322f'
  let g:terminal_color_2  = '#859900'
  let g:terminal_color_3  = '#b58900'
  let g:terminal_color_4  = '#268bd2'
  let g:terminal_color_5  = '#d33682'
  let g:terminal_color_6  = '#2aa198'
  let g:terminal_color_7  = '#073642'
  let g:terminal_color_8  = '#fdf6e3'
  let g:terminal_color_9  = '#cb4b16'
  let g:terminal_color_10 = '#93a1a1'
  let g:terminal_color_11 = '#839496'
  let g:terminal_color_12 = '#657b83'
  let g:terminal_color_13 = '#6c71c4'
  let g:terminal_color_14 = '#586e75'
  let g:terminal_color_15 = '#002b36'
endif
".....................~flattened theme................................

"!!!高亮空白字符
highlight ExtraWhitespace ctermbg=lightred guibg=lightred
match ExtraWhitespace /\s\+$/
augroup HighlightWhitespace
  au BufWinEnter * match ExtraWhitespace /\s\+$/
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhitespace /\s\+$/
  au BufWinLeave * call clearmatches()
augroup END
"~!!!高亮空白字符


noremap <F3> :Autoformat<CR>
augroup AuAutoFormat
  autocmd FileType sh,vim,tex let b:autoformat_autoindent=3
augroup END

"............ open bash..............
function! TermExit(code)
    echom "terminal exit code: ". a:code
endfunc
let opts = {'w':80, 'h':18,'col':winwidth(0)-82, 'line':winheight(0)-19, 'callback':'TermExit'}
let opts.title = 'Terminal Popup'

"t     打开bash窗口
"C-d   退出bash窗口
nmap t :call quickui#terminal#open('bash', opts)<cr>
"..............~open bash....................

 ".............. file menus..........................
 " clear all the menus
 call quickui#menu#reset()
call quickui#menu#install("&File", [
         \ [ "&Open\t(:w)", 'call feedkeys(":tabe ")'],
         \ [ "&Save\t(:w)", 'write'],
         \ [ "--", ],
         \ [ "LeaderF &File", 'Leaderf file', 'Open file with leaderf'],
         \ [ "LeaderF &Mru", 'Leaderf mru --regexMode', 'Open recently accessed files'],
         \ [ "LeaderF &Buffer", 'Leaderf buffer', 'List current buffers in leaderf'],
         \ [ "--", ],
         \ [ "J&unk File", 'JunkFile', ''],
         \ ])

if has('win32') || has('win64') || has('win16')
   call quickui#menu#install('&File', [
            \ [ "--", ],
            \ [ "Start &Cmd", 'silent !start /b cmd /C c:\drivers\clink\clink.cmd' ],
            \ [ "Start &PowerShell", 'silent !start powershell.exe' ],
            \ [ "Open &Explore", 'call Show_Explore()' ],
            \ ])
endif

call quickui#menu#install("&File", [
         \ [ "--", ],
         \ [ "E&xit", 'qa' ],
         \ ])

call quickui#menu#install("&Edit", [
         \ ['Copyright &Header', 'call feedkeys("\<esc> ec")', 'Insert copyright information at the beginning'],
         \ ['&Trailing Space', 'call StripTrailingWhitespace()', ''],
         \ ['Update &ModTime', 'call UpdateLastModified()', ''],
         \ ['&Paste Mode Line', 'PasteVimModeLine', ''],
         \ ['Format J&son', '%!python -m json.tool', ''],
         \ ['--'],
         \ ['&Align Table', 'Tabularize /|', ''],
         \ ['Align &Cheatsheet', 'MyCheatSheetAlign', ''],
         \ ])

call quickui#menu#install('&Symbol', [
         \ [ "&Grep Word\t(In Project)", 'call MenuHelp_GrepCode()', 'Grep keyword in current project' ],
         \ [ "--", ],
         \ [ "Find &Definition\t(GNU Global)", 'call MenuHelp_Gscope("g")', 'GNU Global search g'],
         \ [ "Find &Symbol\t(GNU Global)", 'call MenuHelp_Gscope("s")', 'GNU Gloal search s'],
         \ [ "Find &Called by\t(GNU Global)", 'call MenuHelp_Gscope("d")', 'GNU Global search d'],
         \ [ "Find C&alling\t(GNU Global)", 'call MenuHelp_Gscope("c")', 'GNU Global search c'],
         \ [ "Find &From Ctags\t(GNU Global)", 'call MenuHelp_Gscope("z")', 'GNU Global search c'],
         \ [ "--", ],
         \ [ "Goto D&efinition\t(YCM)", 'YcmCompleter GoToDefinitionElseDeclaration'],
         \ [ "Goto &References\t(YCM)", 'YcmCompleter GoToReferences'],
         \ [ "Get D&oc\t(YCM)", 'YcmCompleter GetDoc'],
         \ [ "Get &Type\t(YCM)", 'YcmCompleter GetTypeImprecise'],
         \ ])

call quickui#menu#install('&Move', [
         \ ["Quickfix &First\t:cfirst", 'cfirst', 'quickfix cursor rewind'],
         \ ["Quickfix L&ast\t:clast", 'clast', 'quickfix cursor to the end'],
         \ ["Quickfix &Next\t:cnext", 'cnext', 'cursor next'],
         \ ["Quickfix &Previous\t:cprev", 'cprev', 'quickfix cursor previous'],
         \ ])

call quickui#menu#install("&Build", [
         \ ["File &Execute\tF5", '!/home/tom/java/run.sh'],
         \ ["File &Compile\tF9", '!./mvnw clean install'],
         \ ["File E&make\tF7", 'AsyncTask emake'],
         \ ["File &Start\tF8", 'AsyncTask emake-exe'],
         \ ['--', ''],
         \ ["&Project Build\tShift+F9", 'AsyncTask project-build'],
         \ ["Project &Run\tShift+F5", 'AsyncTask project-run'],
         \ ["Project &Test\tShift+F6", 'AsyncTask project-test'],
         \ ["Project &Init\tShift+F7", 'AsyncTask project-init'],
         \ ['--', ''],
         \ ["T&ask List\tCtrl+F10", 'call MenuHelp_TaskList()'],
         \ ['E&dit Task', 'AsyncTask -e'],
         \ ['Edit &Global Task', 'AsyncTask -E'],
         \ ['&Stop Building', 'AsyncStop'],
         \ ])

call quickui#menu#install("&Git", [
         \ ['&View Diff', 'call svnhelp#svn_diff("%")'],
         \ ['&Show Log', 'call svnhelp#svn_log("%")'],
         \ ['File &Add', 'call svnhelp#svn_add("%")'],
         \ ])


if has('win32') || has('win64') || has('win16') || has('win95')
   call quickui#menu#install("&Git", [
            \ ['--',''],
            \ ["Project &Update\t(Tortoise)", 'call svnhelp#tp_update()', 'TortoiseGit / TortoiseSvn'],
            \ ["Project &Commit\t(Tortoise)", 'call svnhelp#tp_commit()', 'TortoiseGit / TortoiseSvn'],
            \ ["Project L&og\t(Tortoise)", 'call svnhelp#tp_log()',  'TortoiseGit / TortoiseSvn'],
            \ ["Project &Diff\t(Tortoise)", 'call svnhelp#tp_diff()', 'TortoiseGit / TortoiseSvn'],
            \ ['--',''],
            \ ["File &Add\t(Tortoise)", 'call svnhelp#tf_add()', 'TortoiseGit / TortoiseSvn'],
            \ ["File &Blame\t(Tortoise)", 'call svnhelp#tf_blame()', 'TortoiseGit / TortoiseSvn'],
            \ ["File Co&mmit\t(Tortoise)", 'call svnhelp#tf_commit()', 'TortoiseGit / TortoiseSvn'],
            \ ["File D&iff\t(Tortoise)", 'call svnhelp#tf_diff()', 'TortoiseGit / TortoiseSvn'],
            \ ["File &Revert\t(Tortoise)", 'call svnhelp#tf_revert()', 'TortoiseGit / TortoiseSvn'],
            \ ["File Lo&g\t(Tortoise)", 'call svnhelp#tf_log()', 'TortoiseGit / TortoiseSvn'],
            \ ])
endif

call quickui#menu#install('&Tools', [
         \ ['Compare &History', 'call svnhelp#compare_ask_file()', ''],
         \ ['&Compare Buffer', 'call svnhelp#compare_ask_buffer()', ''],
         \ ['--',''],
         \ ['List &Buffer', 'call quickui#tools#list_buffer("FileSwitch tabe")', ],
         \ ['List &Function', 'call quickui#tools#list_function()', ],
         \ ['Display &Messages', 'call quickui#tools#display_messages()', ],
         \ ['--',''],
         \ ["&DelimitMate %{get(b:, 'delimitMate_enabled', 0)? 'Disable':'Enable'}", 'DelimitMateSwitch'],
         \ ['Read &URL', 'call menu#ReadUrl()', 'load content from url into current buffer'],
         \ ['&Spell %{&spell? "Disable":"Enable"}', 'set spell!', 'Toggle spell check %{&spell? "off" : "on"}'],
         \ ['&Profile Start', 'call MonitorInit()', ''],
         \ ['Profile S&top', 'call MonitorExit()', ''],
         \ ["Relati&ve number %{&relativenumber? 'OFF':'ON'}", 'set relativenumber!'],
         \ ["Proxy &Enable", 'call MenuHelp_Proxy(1)', 'setup http_proxy/https_proxy/all_proxy'],
         \ ["Proxy D&isable", 'call MenuHelp_Proxy(0)', 'clear http_proxy/https_proxy/all_proxy'],
         \ ])

call quickui#menu#install('&Plugin', [
         \ ["&NERDTree\t<space>tn", 'NERDTreeToggle', 'toggle nerdtree'],
         \ ['&Tagbar', '', 'toggle tagbar'],
         \ ["&Choose Window/Tab\tAlt+e", "ChooseWin", "fast switch win/tab with vim-choosewin"],
         \ ["-"],
         \ ["&Browse in github\trhubarb", "Gbrowse", "using tpope's rhubarb to open browse and view the file"],
         \ ["&Startify", "Startify", "using tpope's rhubarb to open browse and view the file"],
         \ ["&Gist", "Gist", "open gist with mattn/gist-vim"],
         \ ["&Edit Note", "Note", "edit note with vim-notes"],
         \ ["&Display Calendar", "Calendar", "display a calender"],
         \ ['Toggle &Vista', 'Vista!!', ''],
         \ ["-"],
         \ ["Plugin &List", "PlugList", "Update list"],
         \ ["Plugin &Update", "PlugUpdate", "Update plugin"],
         \ ])

call quickui#menu#install('Help (&?)', [
         \ ["&Index", 'tab help index', ''],
         \ ['Ti&ps', 'tab help tips', ''],
         \ ['--',''],
         \ ["&Tutorial", 'tab help tutor', ''],
         \ ['&Quick Reference', 'tab help quickref', ''],
         \ ['&Summary', 'tab help summary', ''],
         \ ['--',''],
         \ ['&Vim Script', 'tab help eval', ''],
         \ ['&Function List', 'tab help function-list', ''],
         \ ['&Dash Help', 'call asclib#utils#dash_ft(&ft, expand("<cword>"))'],
         \ ], 10000)

" let g:quickui_show_tip = 1


"----------------------------------------------------------------------
" context menu
"----------------------------------------------------------------------
let g:context_menu_k = [
         \ ["&Peek Definition\tAlt+;", 'call quickui#tools#preview_tag("")'],
         \ ["S&earch in Project\t\\cx", 'exec "silent! GrepCode! " . expand("<cword>")'],
         \ [ "--", ],
         \ [ "Find &Definition\t\\cg", 'call MenuHelp_Fscope("g")', 'GNU Global search g'],
         \ [ "Find &Symbol\t\\cs", 'call MenuHelp_Fscope("s")', 'GNU Gloal search s'],
         \ [ "Find &Called by\t\\cd", 'call MenuHelp_Fscope("d")', 'GNU Global search d'],
         \ [ "Find C&alling\t\\cc", 'call MenuHelp_Fscope("c")', 'GNU Global search c'],
         \ [ "Find &From Ctags\t\\cz", 'call MenuHelp_Fscope("z")', 'GNU Global search c'],
         \ [ "--", ],
         \ [ "Goto D&efinition\t(YCM)", 'YcmCompleter GoToDefinitionElseDeclaration'],
         \ [ "Goto &References\t(YCM)", 'YcmCompleter GoToReferences'],
         \ [ "Get D&oc\t(YCM)", 'YcmCompleter GetDoc'],
         \ [ "Get &Type\t(YCM)", 'YcmCompleter GetTypeImprecise'],
         \ [ "--", ],
         \ ['Dash &Help', 'call asclib#utils#dash_ft(&ft, expand("<cword>"))'],
         \ ['Cpp&man', 'exec "Cppman " . expand("<cword>")', '', 'c,cpp'],
         \ ['P&ython Doc', 'call quickui#tools#python_help("")', 'python'],
         \ ]


"----------------------------------------------------------------------
" hotkey
"----------------------------------------------------------------------
nnoremap <silent><space><space> :call quickui#menu#open()<cr>

"nnoremap <silent>K :call quickui#tools#clever_context('k', g:context_menu_k, {})<cr>

if has('gui_running') || has('nvim')
   noremap <c-f10> :call MenuHelp_TaskList()<cr>
endif
".............. file menus..........................

"............... bufer .............................
"... bclose ......
" Load plugin once.
if exists('g:loaded_bclose')
    finish
endif
let bclose_multiple = 0
let g:loaded_bclose = 1

function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

function! s:Bclose(bang)
    if(!buflisted(winbufnr(0)))
      bw!
      return
    endif
    let s:bufNum = bufnr('%')
    let s:bufName = bufname('%')
    let s:winNum = winnr()
    if empty(a:bang) && getbufvar(s:bufNum, '&modified')
        call s:Warn('No write since last change for buffer '
                    \ .s:bufName. ' (use :Bclose!)')
        return
    endif
    let prevbufvar = bufnr('#')
    if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:bufNum)
        bn
    else
       bn
    endif
    execute s:winNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr('$')
    let l:i = 1
    if( len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1)
    while(l:i < l:nBufs)
      if(l:i != s:bufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile

    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr('%')
        windo if(buflisted(winbufnr(0))) | execute 'b! ' . l:newBuf | endif
      endif
      execute s:winNum . 'wincmd w'
    endif

    if(buflisted(s:bufNum) || s:bufNum == bufnr('%'))
      execute 'bw! ' . s:bufNum
    endif

    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
    endif
endfunction

command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>')
nnoremap <silent> <Plug>Bclose :<C-u>Bclose<CR>
"...... ~bclose .........
"!!! 鼠标双击 进入文件或目录，
"!!! c-h 进入上层目录
"!!! bo  打开目录树
"!!! bc  关闭当前窗口
"!!! bn  下一个文件
"!!! bp  上一个文件
"!!! bf  第一个文件
"!!! bl  最后一个文件
nmap <silent>bo :Fern . -drawer -keep<cr>
nmap <silent>bn :bnext<cr>
nmap <silent>bp :bprevious<cr>
nmap <silent>bc :Bclose<cr>
nmap <silent>bf :bfirst<cr>
nmap <silent>bl :blast<cr>

"nnoremap <2-LeftMouse> <LeftMouse>:call feedkeys("\<Plug>(fern-action-open-or-enter)")<cr>
"...............~bufer .............................


"..........pairs...............
au FileType * let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'})
"..........~pairs...............

"..........TagList...........................
let Tlist_Show_One_File = 1 " 只显示当前文件的tags
let Tlist_GainFocus_On_ToggleOpen = 1 " 打开 Tlist 窗口时，光标跳到 Tlist 窗口

let Tlist_Exit_OnlyWindow = 1 " 如果 Tlist 窗口是最后一个窗口则退出 Vim
let Tlist_Use_Left_Window = 1 " 在左侧窗口中显示

let Tlist_File_Fold_Auto_Close = 1 " 自动折叠
let Tlist_Auto_Update = 1 " 自动更新


" <leader>tl 打开 Tlist 窗口，在左侧栏显示
map <leader>tl :TlistToggle<CR>
"..........~TagList...........................


"................. git 修正RPC错误.......................
" $ apt remove git
" $ apt install zlib1g zlib1g-dev libcurl4-openssl-dev gcc make tcl gettext
" $ sudo dnf install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel
" $ sudo apt install dh-autoreconf libcurl4-gnutls-dev
" $ sudo apt libexpat1-dev gettext libz-dev zlib1g-dev tcl build-essential tk asciidoc xmlto docbook2x
"
" $ 下载 https://github.com/git/git/tags
" $ make configure
" $ ./configure --prefix=/usr
" $ make all doc info
" $ make install install-doc install-html install-info
"................. git 修正RPC错误.......................


let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" Use preset argument to open it
nmap <space>ed <Cmd>CocCommand explorer --preset .vim<CR>
nmap <space>ef <Cmd>CocCommand explorer --preset floating<CR>
nmap <space>ec <Cmd>CocCommand explorer --preset cocConfig<CR>
nmap <space>eb <Cmd>CocCommand explorer --preset buffer<CR>

" List all presets
nmap <space>el <Cmd>CocList explPresets<CR>
root@tom:/home/tom/idc# 
