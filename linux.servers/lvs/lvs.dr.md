**LVS DR**
```
1)架构:
  vip: 192.168.56.100
    ld1: eth0 192.168.56.101  eth0:0 192.168.56.100
    ld2: eth0 192.168.56.102  eth0:0 192.168.56.100

  rs1: 192.168.56.103
  rs2: 192.168.56.104

2)LoadBalancerServer:

echo 1 > /proc/sys/net/ipv4/ip_forward
  
#!!!DR模式中前后端口必须一样
ipvsadm -A -t 192.168.56.100:80 -s wlc
ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.103:80 -g -w 1
ipvsadm -a -t 192.168.56.100:80 -r 192.168.56.104:80 -g -w 1

ipvsadm --save > /etc/sysconfig/ipvsadm 


3)RealServer:
  A)#arp抑制
    echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce

  B)#lo:0
    ifconfig lo:0 192.168.56.100 netmask 255.255.255.255 broadcast 192.168.56.100 up
    route add -host 192.168.56.100 dev lo:0

  C)#nginx server
  a)rs1:
  apt install nginx
  rs1 eth0 192.168.56.103
  apt install nginx
  echo 56.103 > /var/www/html/index.nginx-debian.html 
  
  b)rs2:
  rs1 eth0 192.168.56.104
  apt install nginx
  echo 56.104 > /var/www/html/index.nginx-debian.html 

4)在其它服务器上测试(不能在LD上访问)
  $ curl http://192.168.56.100
   56.103
   
  $ curl http://192.168.56.100
   56.104
   
  $ curl http://192.168.56.100
   56.103
```
