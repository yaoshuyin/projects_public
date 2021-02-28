**阿里云源**
```bash
$ cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
$ wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
$ yum update
```

**关闭SELinux**
```bash
$ getenforce
$ sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
$ setenforce 0
$ getenforce
```
