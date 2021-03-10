```console
.查找大目录
find / -maxdepth 1 -type d ! -path "/proc" ! -path "/run" ! -path "/dev" ! -path "/" -exec du -sh {} \;

```
