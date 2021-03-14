**dhcp server**
```consoledhcpd -4 -f -d -s 169.254.13.1 -cf dhcpd.conf -lf leases
$ ifconfig eth0:0 192.168.10.1 up

$ yum install dhcp dhclient

# 修改/etc/systemd/system/multi-user.target.wants/dhcpd.service，在ExecStart后添加要做DHCP的网卡

$ vim /etc/systemd/system/multi-user.target.wants/dhcpd.service
[Unit]
Description=DHCPv4 Server Daemon
Documentation=man:dhcpd(8) man:dhcpd.conf(5)
Wants=network-online.target
After=network-online.target
After=time-sync.target

[Service]
Type=notify
ExecStart=/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid eth0:0

[Install]
WantedBy=multi-user.target

$ vim /etc/dhcp/dhcpd.conf
default-lease-time 3600;
log-facility local7;

subnet 192.168.10.0 netmask 255.255.255.0 {
   authoritative;
   range 192.168.10.30 192.168.10.200;
   default-lease-time 3600;
   max-lease-time 172800;
   option subnet-mask 255.255.255.0;
   option broadcast-address 192.168.10.255;
   option routers 192.168.10.1;
   option domain-name-servers 8.8.4.4;
   #option domain-name "a.com";
}

$ systemctl enable dhcpd
$ systemctl start dhcpd

test
$ yum install dhclient
$ ifconfig eth0:1 192.168.10.10 up
$ dhclient -d eth0:1
```
