**阿里源**
```bash
CentOSVer=7
mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-$CentOSVer.repo

mv -f /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv -f /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-$CentOSVer.repo

grep 'name=Aliyun-' /etc/yum.repos.d/epel.repo || sed -i 's/name=/name=Aliyun-/g' /etc/yum.repos.d/epel.repo

yum makecache
yum update
```

**test**
```bash
$ yum repolist
Loaded plugins: fastestmirror, langpacks, ovl
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * centos-sclo-rh: mirrors.163.com
 * centos-sclo-sclo: mirrors.163.com
 * extras: mirrors.aliyun.com
 * remi-php74: mirrors.tuna.tsinghua.edu.cn
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 * updates: mirrors.aliyun.com
repo id                     repo name                                                   status
base/7/x86_64               CentOS-7 - Base - mirrors.aliyun.com                        10,072
updates/7/x86_64            CentOS-7 - Updates - mirrors.aliyun.com                      1,729
extras/7/x86_64             CentOS-7 - Extras - mirrors.aliyun.com                         453
epel/x86_64                 Aliyun-Extra Packages for Enterprise Linux 7 - x86_64       13,550

centos-sclo-rh/x86_64       CentOS-7 - SCLo rh                                           7,145
centos-sclo-sclo/x86_64     CentOS-7 - SCLo sclo                                           816

mysql57-community/x86_64    MySQL 5.7 Community Server                                     484

remi-php74                  Remi's PHP 7.4 RPM repository for Enterprise Linux 7 - x86_    394
remi-safe                   Safe Remi's RPM repository for Enterprise Linux 7 - x86_64   4,143

zabbix/x86_64               Zabbix Official Repository - x86_64                            215
zabbix-frontend/x86_64      Zabbix Official Repository frontend - x86_64                    93
zabbix-non-supported/x86_64 Zabbix Official Repository non-supported - x86_64                4

repolist: 39,098

$ yum list nginx
 * base: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * centos-sclo-rh: mirrors.163.com
 * centos-sclo-sclo: mirrors.163.com
 * remi-php74: mirrors.tuna.tsinghua.edu.cn
 * remi-safe: mirrors.tuna.tsinghua.edu.cn
 
Installed Packages
nginx.x86_64                               1:1.16.1-3.el7                                @epel
```
