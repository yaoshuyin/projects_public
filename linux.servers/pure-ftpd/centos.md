***Install***
```bash
$ yum install pure-ftpd ftp
```

***config***
```bash
$ vim /etc/pure-ftpd/pure-ftpd.conf

...
PureDB                  /etc/pure-ftpd/pureftpd.pdb   #一定要去掉前面的#否则不起作用
...
PassivePortRange        30000 50000
ForcePassiveIP          192.168.1.100
...
Bind                    0.0.0.0,21

$ systemctl restart pure-ftpd

```

***添加用户***
```bash
$ useradd -s /sbin/nologin pureftp
$ pure-pw useradd pureftp -u pureftp -d /home/logs
$ pure-pw mkdb 
```

***客户端口挂载***
```bash
$ yum install curlftpfs
  
#mount
$ curlftpfs -o codepage=utf8 ftp://pureftp:123456@192.168.1.100:/ /tmp/logs

#umount
$ fusermount -u /tmp/logs
```
