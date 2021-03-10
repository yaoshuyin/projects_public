**use vimdiff**
```console
#vimdiff 有可能因为 interactive shell 的设置而导致无法启用
echo "set shellcmdflag=-c" >> ~/.bashrc
set shellcmdflag=-c
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global alias.d difftool

```

**conflict**
```console
$ git diff find.md 
diff --cc commands/find.md
index a04087f,489852c..0000000
--- a/commands/find.md
+++ b/commands/find.md
@@@ -1,5 -1,5 +1,9 @@@
  ```console
  .查找大目录
  find / -maxdepth 1 -type d ! -path "/proc" ! -path "/run" ! -path "/dev" ! -path "/" -exec du -sh {} \;
++<<<<<<< HEAD
 + 
++=======
+ 
++>>>>>>> 4d421f6f221de24004976b1b0dd3ebb44c939e16
  ```

$ vim find.md 删除" +" +号前面的空格,保存
$ git add commands/find.md 
$ git commit -m "add find"
$ git push 
$ git pull

```
