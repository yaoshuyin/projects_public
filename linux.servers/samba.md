**install**
```console
$ yum -y install samba cfs-utils
$ mkdir -p /samba/data
$ chmod 777 /samba/data
$ cp /etc/hosts /samba/data 
```

**config**
```console
$ useradd test -s /sbin/nologin
$ smbpasswd -a test

$ vim /etc/samba/smb.conf
[data]
   path=/samba/data
   valid users= test
   hosts allow=192.168.0.
   write list = test
   writable=yes
   create mask = 0664
   directory mask = 0775
   browseable = yes
   printable = yes

$ systemctl enable nmb smb
$ systemctl start nmb smb

$ firewall-cmd --permanent --add-service=samba
$ firewall-cmd --permanent --add-service=samba-client
$ firewal-cmd --permanent --add-service=mountd 

#windows
1)命令行挂载
\\192.168.0.100

2)驱动器映射

