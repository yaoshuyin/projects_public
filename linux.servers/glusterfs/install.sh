
............................................ gluster install .................................................

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

............................................ heketi install .................................................

  yum install heketi heketi-client
  
  vim /etc/heketi/heketi.json 
   {
     .....
     
     "port": "18080",
   
     "use_auth": false,
   
     "jwt": {
       "_admin": "Admin has access to all APIs",
       "admin": {
         "key": "admin"
       },
       "_user": "User only has access to /volumes endpoint",
       "user": {
         "key": "user"
       }
     },
   
       "executor": "ssh",
   
       "_sshexec_comment": "SSH username and private key file information",
       "sshexec": {
         "keyfile": "/etc/heketi/id_rsa",
         "user": "root",
         "port": "22",
         "fstab": "/etc/fstab"
       },
   
     }
     ....
   }

  ssh-copy-id root@gfs-node1
  ssh-copy-id root@gfs-node2
  ssh-copy-id root@gfs-node3 
   
  cp /root/.ssh/id_rsa /etc/heketi/
  chown -R heketi:heketi /etc/heketi/id_rsa 
   
  chown -R heketi:heketi /var/lib/heketi
  
  systemctl restart heketi
  systemctl status heketi 
  
  vim /etc/heketi/topology.json
{
    "clusters": [
        {
            "nodes": [
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "192.168.56.101"
                            ],
                            "storage": [
                                "192.168.56.101"
                            ]
                        },
                        "zone": 1
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                },
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "192.168.56.102"
                            ],
                            "storage": [
                                "192.168.56.102"
                            ]
                        },
                        "zone": 2
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                },
                {
                    "node": {
                        "hostnames": {
                            "manage": [
                                "192.168.56.103"
                            ],
                            "storage": [
                                "192.168.56.103"
                            ]
                        },
                        "zone": 3
                    },
                    "devices": [
                        "/dev/sdb"
                    ]
                }
            ]
        }
    ]
} 
 
  heketi-cli --server http://localhost:18080 --user admin --secret admin topology load --json=/etc/heketi/topology.json
  heketi-cli --server http://localhost:18080 --user admin --secret admin topology info 

.k8s-node01 / k8s-node2 / k8s-node2
 yum install glusterfs-fuse
