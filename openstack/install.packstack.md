**packstack install openstack**
```console
#参考: https://www.jianshu.com/p/3fe87399ba78?from=singlemessage
1)virtualbox
  cpu: 2Core
  mem: 3GB
  网卡: enp0s3  nat   enp0s18  hostonly

  python2 
 
  virtualbox -- 主机网络管理 -- 创建:
     手动配置网卡
        IPv4地址: 172.30.14.1
        网络掩码: 255.255.255.0
        
     DHCP服务器: 去掉 启用服务器
   
2)下载CentOS7
https://mirrors.tuna.tsinghua.edu.cn/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso

3)
$ cat /etc/redhat-release 
    CentOS Linux release 7.9.2009 (Core)

$ hostnamectl set-hostname openstack
$ vi /etc/hosts
   172.30.14.10  openstack
 
$ yum -y update
$ yum install epel-release
$ yum -y update
$ yum -y install yum-utils net-tools
 
#!!! 很重要
$ yum downgrade leatherman

$ systemctl stop NetworkManager
$ systemctl disable NetworkManager

$ vi /etc/selinux/config
$ systemctl disable firewalld
$ systemctl stop firewalld
 
$ systemctl stop NetworkManager
$ systemctl status NetworkManager

$ systemctl enable network
$ systemctl start network
$ systemctl status network

.安装lvm2软件包
$ yum install lvm2 -y

.启动LVM的metadata服务并且设置该服务随系统启动
$ systemctl enable lvm2-lvmetad.service
$ systemctl start lvm2-lvmetad.service

$ pvcreate /dev/sdb
$ vgcreate cnider-volumes /dev/sdb

$ pvcreate /dev/sdc
$ vgcreate lxc /dev/sdc

$ yum install -y centos-release-openstack-queens
$ yum -y update
$ reboot


$ yum install -y openstack-packstack

$ ssh-keygen
$ ssh-copy-id root@172.30.14.10

$ packstack --gen-answer-file /root/openstack-answer.txt --install-hosts==172.30.14.10,172.30.14.10 --ssh-public-key=/root/.ssh/id_rsa.pub --default-password=123456 --mariadb-host=172.30.14.10 --os-swift-install=y
$ vi /root/openstack-answer.txt
  CONFIG_CONTROLLER_HOST=172.30.14.10
  CONFIG_COMPUTE_HOSTS=172.30.14.10
  CONFIG_NETWORK_HOSTS=172.30.14.10

  CONFIG_STORAGE_HOST=172.30.14.10
  CONFIG_SAHARA_HOST=172.30.14.10
  CONFIG_SSL_CERT_SUBJECT_CN=172.30.14.10
  CONFIG_SSL_CERT_SUBJECT_MAIL=admin@172.30.14.10
  CONFIG_AMQP_HOST=172.30.14.10
  CONFIG_MARIADB_HOST=172.30.14.10
  CONFIG_KEYSTONE_LDAP_URL=ldap://172.30.14.10
  CONFIG_REDIS_HOST=172.30.14.10

#!!! 保存好openstack-answer.txt, 以后扩容再用
$ packstack --answer-file=/root/openstack-answer.txt 
 
.开启另一个Termnial
$ ps -ef|grep python
   /usr/bin/python2 /usr/bin/packstack --answer-file=/root/packstack-answers-20210315-080444.txt
   /usr/bin/python2 -Es /usr/sbin/tuned -l -P
   /usr/bin/python /usr/bin/yum -d 0 -e 0 -y install python-openstackclient
   /usr/bin/python /usr/libexec/urlgrabber-ext-down
   /usr/bin/python /usr/libexec/urlgrabber-ext-down
   ...


.登陆测试
http://172.30.14.10/dashboard
user: admin
pass: 34561649c218494d  (使用/root/openstack-answer.txt： CONFIG_KEYSTONE_ADMIN_PW)

................................

.报错信息
1.添加语言支持
vi /etc/environment
LANG=en_US.utf-8
LC_ALL=en_US.utf-8

2.Permanently added 'XXXXXXX' (ECDSA) to the list of known hosts
修改/etc/ssh/ssh_config
StrictHostKeyChecking ask 改成
StrictHostKeyChecking no

3.leatherman_curl.so.1.3.0: cannot open shared
需要回退leatherman版本到1.3.0
yum downgrade leatherman
```
