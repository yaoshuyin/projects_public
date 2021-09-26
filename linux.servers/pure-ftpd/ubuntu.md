***install***
```bash
$ apt install pure-ftpd
```

***config***
```bash
$ echo "30000 33000" > /etc/pure-ftpd/conf/PassivePortRange
$ echo "192.168.1.100" > /etc/pure-ftpd/conf/ForcePassiveIP
$ id backup
   uid=34(backup) gid=34(backup) groups=34(backup)
$ echo 30 > /etc/pure-ftpd/conf/MinUID

$ pure-pw useradd backup -u backup -d /data/backup
$ pure-pw mkdb

$ ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/conf/auth/60puredb

$ systemctl restart pure-ftpd
```

***ufw***
```bash
$ ufw allow 20:21/tcp
$ ufw allow 30000:33000/tcp
```

***客户端口挂载***
```bash
$ apt install curlftpfs
  
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

#umount
$ fusermount -u /tmp/logs
```
