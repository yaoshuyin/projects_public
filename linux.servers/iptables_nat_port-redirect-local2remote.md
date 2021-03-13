**iptables nat**

```bash
:<<_EOF_
Author: cnscn
Script: redirect.sh
功能:   本机端口 重定向到 其他服务器端口
环境:
  本机IP:    172.18.0.9
  dest_host: 172.18.0.100

  目的:      client --> 172.18.0.9:8888 --> 172.18.0.100:80
             client --> 172.18.0.9:2222 --> 172.18.0.100:22

Usage: ./redirect.sh server_eth server_port  dest_host dest_port
       ./redirect.sh eth0 8888 172.18.0.8 80
       ./redirect.sh eth0 2222 192.168.0.100 22

test:
  $ redirect eth0 8888 172.18.0.8 80
  $ nc -vz 192.168.101.18 8888
    Connection to 192.168.101.18 8888 port [tcp/*] succeeded!
  
  $ nc -vz -w 2 127.0.0.1 8888
  nc: connect to 127.0.0.1 port 9999 (tcp) timed out
_EOF_

function redirect_local2remote()
{
   server_eth=$1
   server_port=$2
   
   dest_host=$3
   dest_port=$4
   
   echo 1 > /proc/sys/net/ipv4/ip_forward
   
   #此条允许从本机访问本机的除lo以外网卡上IP:端口
   #如curl http://192.168.0.100:8888 .. ok
   iptables -t nat -A OUTPUT -p tcp --dport $server_port -j DNAT --to $dest_host:$dest_port
   
   #需要添加此条，才能供本机以外的主机来访问本机的9974端口
   iptables -t nat -A PREROUTING -p tcp --dport $server_port -j DNAT --to $dest_host:$dest_port
   
   
   #如果不能访问，可以尝试添加下面两条
   #iptables -t nat -A POSTROUTING -o $server_eth -j MASQUERADE 
   #iptables -A FORWARD -i $server_eth -p tcp --dport $dest_port -d $dest_host -j ACCEPT
   
   #!!!注意：不能使用127.0.0.1访问，因为localhost、127.0.0.1不过nat
   #curl http://127.0.0.1:9974 .. failed  ()
}

redirect_local2remote $1 $2 $3 $4
```
