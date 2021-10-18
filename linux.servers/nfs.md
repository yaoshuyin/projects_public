
### Server (192.168.1.100) ###
```bash
1)install
  yum install nfs-utils -y

  systemctl enable rpcbind
  systemctl start rpcbind
  systemctl status rpcbind
 
  systemctl enable nfs
  systemctl start nfs 
  systemctl status nfs

2)firewall
  firewall-cmd --permanent --add-service=nfs
  firewall-cmd --permanent --add-service=mountd
  firewall-cmd --permanent --add-service=rpc-bind
  firewall-cmd --reload

3)配置
  $ vim /etc/exports
/opt/abc 192.168.1.101/32(ro)   localhost(rw)
```

### client (192.168.1.101) ###
```bash
1)install
  yum install nfs-utils -y

2)挂载
  mkdir -p /opt/abc
  mount -t nfs 10.133.1.100:/opt/abc /opt/abc
```
