```
.root 密码修改
$ yum install openstack-utils
$ openstack-service restart nova

$ yum install guestfish

$ export LIBGUESTFS_BACKEND=direct
$ guestfish --rw -a CentOS-7-x86_64-GenericCloud-2009.qcow2
><fs> run
><fs> list-filesystems
/dev/sda1: xfs

><fs> mount /dev/sda1 /

><fs> vi /etc/cloud/cloud.cfg
disable_root: 0
ssh_pwauth: 1
chpasswd:
  list: |
    root:123456
  expire: False
保存推出:wq
><fs> quit

openstack image create "CentOS7-mini" \
  --file CentOS-7-x86_64-GenericCloud-2009.qcow2c \
  --disk-format qcow2 --container-format bare \
  --public
  

$ export LIBGUESTFS_BACKEND=direct

$ virt-df CentOS-7-x86_64-GenericCloud-2009.qcow2

 openstack server create --flavor m1.nano --image CentOS7-mini \
  --nic net-id=10ad5cd3-342e-4ed2-a9f2-7ddc06b99db3 --security-group default \
  --key-name testkey centos7-cloudvm1 
```
