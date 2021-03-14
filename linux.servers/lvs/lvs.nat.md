**LVS NAT**
```console
!!! vip/ld/rs 在同一网段

1)架构:
  vip: 192.168.56.100
    ld1: eth0 192.168.56.101  eth0:0 192.168.56.100
    ld2: eth0 192.168.56.102  eth0:0 192.168.56.100

  rs1: 192.168.56.103
  rs2: 192.168.56.104

2)load balancer
a) ld1 eth0 192.168.56.101

echo >> /etc/rc.local <<EOF
  echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/ipvsadm -A -t 192.168.56.100:80 -s wrr
  /usr/sbin/ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.103:80 -m -w 1
  /usr/sbin/ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.104:80 -m -w 1
EOF

b) ld1 eth0 192.168.56.102

echo >> /etc/rc.local <<EOF
  echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/ipvsadm -A -t 192.168.56.100:80 -s wrr
  /usr/sbin/ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.103:80 -m -w 1
  /usr/sbin/ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.104:80 -m -w 1
EOF

3)real server
  a) rs1 eth0 192.168.56.103
     apt install nginx
     echo 56.103 > /var/www/html/index.nginx-debian.html 
  
  2) rs2 eth0 192.168.56.104
     apt install nginx
     echo 56.104 > /var/www/html/index.nginx-debian.html 
  
4)test
$ curl http://192.168.56.100
   56.103
   
$ curl http://192.168.56.100
   56.104
   
$ curl http://192.168.56.100
   56.103
```
