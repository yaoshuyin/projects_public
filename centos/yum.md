**阿里源**
```bash
CentOSVer=7
mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-$CentOSVer.repo

mv -f /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv -f /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-$CentOSVer.repo

yum makecache

yum repolist
```
