***节点（三个节点都执行）***
```
/etc/hosts
10.133.30.25 prod-glusterfs-01
10.133.30.26 prod-glusterfs-02
10.133.30.27 prod-glusterfs-03
```

***安装（三个节点都执行）***
``` 
  systemctl stop firewalld
  systemctl disable firewalld

  yum -y install centos-release-gluster9.noarch
  yum -y --enablerepo=centos-gluster9-test clean all
  rpm -ivh https://buildlogs.centos.org/centos/7/storage/x86_64/gluster-9/Packages/u/userspace-rcu-0.10.0-3.el7.x86_64.rpm
  rpm -ivh https://buildlogs.centos.org/centos/7/storage/x86_64/gluster-9/Packages/u/userspace-rcu-devel-0.10.0-3.el7.x86_64.rpm
  yum --enablerepo=centos-gluster9-test install glusterfs-server
  yum  -y install  centos-release-gluster
  yum -y  install  glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma
  
  systemctl enable glusterd.service
  systemctl start glusterd.service

  gluster peer probe prod-glusterfs-01 
  gluster peer probe prod-glusterfs-02 
  gluster peer probe prod-glusterfs-03

  gluster peer status
```

***测试***
```
#.三个节点都执行
mkdir -p /data/gfs/pv1

#.创建卷  (prod-glusterfs-01执行）
gluster volume create pv1 replica 3 prod-glusterfs-01:/data/gfs/pv1 prod-glusterfs-02:/data/gfs/pv1 prod-glusterfs-03:/data/gfs/pv1 force
gluster volume start pv1
gluster volume list

#.挂载测试 （客户端需要 把glusterfs三台的ip hostname加入到自己的/etc/hosts中，否则 挂载报错）
mkdir /opt/pv1
mount -t glusterfs prod-glusterfs-01:pv1 /opt/pv1

#.停止与删除
gluster volume stop pv1 
gluster volume delete pv1 

rm -fr /data/gfs/pv1/{.glusterfs,.trashcan }
```
