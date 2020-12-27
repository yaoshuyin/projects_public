./etc/hosts  (三个节点都执行）
192.168.56.101 gfs-master01
192.168.56.102 gfs-master02
192.168.56.103 gfs-master03

.安装  (三个节点都执行）
yum install -y centos-release-gluster
yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma

.启动服务 (三个节点都执行）
systemctl enable glusterd.service
systemctl start glusterd.service

.加入节点  (gfs-master01执行）
gluster peer probe gfs-master01
gluster peer probe gfs-master02
gluster peer probe gfs-master03

.查看节点状态  (gfs-master01执行）
gluster peer status

.三个节点都执行
mkdir -p /data/gfs/pv1

.创建卷  (gfs-master01执行）
gluster volume info
gluster volume create pv1 replica 3 gfs-master01:/data/gfs/pv1 gfs-master02:/data/gfs/pv1 gfs-master03:/data/gfs/pv1 force

gluster volume info

gluster volume start pv1

mount -t glusterfs gfs-master01:pv1 /opt/pv1
gluster volume list 

.停止与删除
gluster volume stop pv1 
gluster volume delete pv1 

rm -fr /data/gfs/pv1/{.glusterfs,.trashcan }
