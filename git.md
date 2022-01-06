## !!!国内代理!!!
```
git config --global url."https://github.com.cnpmjs.org/".insteadOf "https://github.com/"
git config --global protocol.https.allow always


https://hub.fastgit.org/ 下载速度快，但库不全
github.com.cnpmjs.org  下载速度还可以，但库全

其它代理
ssh:
  ssh.fastgit.org

raw:
  https://raw.githubusercontent.com/ ==> https://raw.fastgit.org/

 
github.githubassets.com       assets.fastgit.org 	无
customer-stories-feed.github.com    customer-stories-feed.fastgit.org 
Github Download               download.fastgit.org 
GitHub Archive                archive.fastgit.org
```
 


## 分支
```
#创建新分支abc
$ git branch abc

#从分支38b7da45e创建新分支abc
$ git branch abc 38b7da45e

#切换到新分支abc
$ git checkout abc

#创建并切换到新分支abc
$ git checkout -b abc
```

## tag
```
1)创建v1.0.0标签，并加备注
  $ git tag v1.0.0 -m "202108081638"

  推送到远程
  $ git push origin --tag v1.0.0

2)列出所有tag
  $ git tag -l

3)删除本地tag
  $ git tag -d v1.0.0

  删除远程tag
  $ git push origin :refs/tags/v1.0.0
```
