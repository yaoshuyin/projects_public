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

**时间同步**
```bash
$ echo 'TZ='Asia/Shanghai'; export TZ' >> /etc/profile
$ . /etc/profile

$ yum install ntp
$ systemctl enable ntpd
$ systemctl start ntpd

$ ntpq
ntpq> peers
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
+ntp1.ams1.nl.le 130.133.1.10     2 u   34   64    7  224.788  -11.994  19.761
*a.chl.la        131.188.3.222    2 u   32   64    7  230.235  -13.394  24.939
 ntp8.flashdance 192.36.143.151   2 u   34   64    3  282.903   19.176  21.946
+ntp5.flashdance 192.36.143.153   2 u   30   64    7  230.823    6.732  24.543
```

