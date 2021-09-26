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

***firewalld***
```bash
$ firewall-cmd --new-service=pureftpd --permanent

$ firewall-cmd --service=pureftpd --add-port=20-21/tcp --permanent
$ firewall-cmd --service=pureftpd --add-port=30000-33000/tcp --permanent

$ firewall-cmd --reload

$ firewall-cmd --zone=public --add-service=pureftpd --permanent
$ firewall-cmd --reload
```

***客户端口挂载***
```bash
$ yum install curlftpfs
  
#mount
$ curlftpfs -o codepage=utf8 ftp://pureftp:123456@192.168.1.100:/ /tmp/logs
或
$ cat > /root/.netrc <<EOF
machine 192.168.1.100
login pureftp
password 123456
EOF
$ chmod 600 /root/.netrc
$ curlftpfs -o codepage=utf8 ftp://192.168.1.100:/ /tmp/logs

#fstab挂载
$ echo 'curlftpfs#pureftp:123456@192.168.1.100 /tmp/logs fuse rw,uid=500,gid=500,user,noauto 0 0'  >>/etc/fstab

#umount
$ fusermount -u /tmp/logs
```
