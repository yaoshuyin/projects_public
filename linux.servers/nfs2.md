***Server***
```bash
1)install
$ yum install rpcbind nfs nfs-utils

2)exports
$ vim /etc/exports
/model                            *(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
/home/ydfls/logs 192.168.60.110/32(ro,sync,no_root_squash)
/opt/logs        192.168.60.110/32(ro,sync,no_root_squash)

3)service
$ systemctl enable rpcbind
$ systemctl enable nfs
$ systemctl enable nfs-mountd

$ systemctl restart rpcbind
$ systemctl restart nfs
$ systemctl restart nfs-mountd

4)firewall
firewall-cmd --permanent --zone public --add-service mountd
firewall-cmd --permanent --zone public --add-service rpc-bind
firewall-cmd --permanent --zone public --add-service nfs
firewall-cmd --reload 
```

***client***
```bash
$ vim /etc/fstab
10.133.30.61:/opt/logs /home/ydfls/ys-logs/opt nfs auto,noatime,nolock,bg,nfsvers=4,intr,tcp,actimeo=1800 0 0
10.133.30.61:/home/ydfls/logs /home/ydfls/ys-logs/home nfs auto,noatime,nolock,bg,nfsvers=4,intr,tcp,actimeo=1800 0 0
```
 
```
all_squash
   将远程访问的所有普通用户及所属组都映射为nobody,此为默认设置
no_all_squash

root_squash
   将root用户及所属组都映射为匿名用户或组

no_root_squash

anonuid 将远程访问的所有用户都映射为匿名用户，并指定此用户为本地用户
anongid 将远程访问的所有用户组都映射为匿名用户组，并指定此用户为本地用户组


.后台进程
rpc.nfsd

rpc.lockd  抓取文件锁
rpc.statd  抓取文件锁

rpc.mountd 初始化客户端的mount请求

.确认nfs服务是否正常
$ rpcinfo -p
$ showmount -e 127.0.0.1
rpc.rquotad 负责对客户文件的磁盘配额
```
