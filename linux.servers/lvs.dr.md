**LVS DR**
```
1)架构:
  vip: 192.168.56.110
    ld1: eth0 192.168.56.101  eth0:0 192.168.56.110
    ld2: eth0 192.168.56.102  eth0:0 192.168.56.110

  rs1: 192.168.56.103
  rs2: 192.168.56.104

2)LoadBalancerServer:

echo 1 > /proc/sys/net/ipv4/ip_forward
  
#!!!DR模式中前后端口必须一样
ipvsadm -A -t 192.168.56.100:80 -s wlc
ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.101:80 -g -w 1
ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.102:80 -g -w 1

ipvsadm --save > /etc/sysconfig/ipvsadm 


3)RealServer:
  A)#arp抑制
    echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce

  B)#lo:0
    ifconfig lo:0 192.168.56.110 netmask 255.255.255.255 broadcast 192.168.56.110 up
    route add -host 192.168.56.110 dev lo:0

  C)#nginx server
  a)rs1:
  apt install nginx
  rs1 eth0 192.168.56.101
  apt install nginx
  echo 56.101 > /var/www/html/index.nginx-debian.html 
  
  b)rs2:
  rs1 eth0 192.168.56.102
  apt install nginx
  echo 56.102 > /var/www/html/index.nginx-debian.html 

4)在其它服务器上测试(不能在LD上访问)
  $ curl http://192.168.56.101
   56.101
   
  $ curl http://192.168.56.102
   56.102
   
  $ curl http://192.168.56.101
   56.101
```
