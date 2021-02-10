**install**
```bash
$ cd /data/Spiders/tmp2/
$ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
$ php composer-setup.php --install-dir=/usr/local/bin/
$ ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

$ composer init
$ vim composer.json
{ 
   ...
   "minimum-stability": "dev",
   "prefer-stable": true,
   "require": {
      "felixfbecker/language-server": "^5.4",
      "jetbrains/phpstorm-stubs": "dev-master#89eb456a21704cb5dd3020367765b0a1993e4623"
   }
}

$ rm -f composer.lock
$ composer install
$ composer update
$ composer -vvv require felixfbecker/language-server
$ composer -vvv run-script --working-dir=vendor/felixfbecker/language-server parse-stubs 
$ 如果出现错误，则 vim +180 /data/Spiders/tmp2/vendor/phpdocumentor/type-resolver/src/TypeResolver.php
          change 
                  if (count($types) === 0) {
                      throw new RuntimeException(                                                                                  
                          'A type is missing before a type separator'
                      );
                  }

to 
                  if (count($types) === 0) {
                      //throw new RuntimeException(                                                                                  
                      //    'A type is missing before a type separator'
                      //);
                  }
$ composer -vvv run-script --working-dir=vendor/felixfbecker/language-server parse-stubs

$ php vendor/felixfbecker/language-server/bin/php-language-server.php --tcp-server=127.0.0.1:12345
   测试正常则按 Ctrl-c 关闭之
```

```vim
   Plug 'prabirshrestha/vim-lsp'                                                                       
   Plug 'mattn/vim-lsp-settings
```

**config**
```vim
     au User lsp_setup call lsp#register_server({                                                      
         \ 'name': 'php',
         \ 'cmd': {server_info->['php', expand('/data/Spiders/tmp2/vendor/felixfbecker/language-server/
         \ 'whitelist': ['php'],
         \ })
  
     autocmd FileType php setlocal omnifunc=lsp#complete
```

**usage**
```vim a.php
1)
第一次运行PHP，需要在vim里面执行 :LspInstallServer

2)
<?php
class A{
   function func($x,$y,$z) {
   }
}

$obj=new A();
$obj-><C-x><C-o>
```
