**nmcli**

```console
$ nmcli device
$ nmcli device show
$ nmcli device show ens33
$ nmcli connection
$ nmcli connection up ens33-xxx
$ nmcli connection delete ens33-xxx

$ vim /etc/sysconfig/network-scripts/ifcf-ens33
NAME="ens33"
DEVICE="ens33"
ONBOOT=yes
NETBOOT=yes
BOOTPROTO=none
IPADDR=192.168.1.16
PREFIX=24
IPADDR1=192.168.1.17
PREFIX1=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
$ nmcli connection reload
$ nmcli connection down ens33-xxx; nmcli connection up ens33-xxx

```

**nmtui**
```console
$ nmtui
```
