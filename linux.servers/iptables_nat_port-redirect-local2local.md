** iptables port redirect_local2local**
```bash
:<<_EOF_
Author: cnscn
Script: redirect.sh

功能:  本机端口sport 转发到本机dport

Usage: ./redirect.sh sport dport 
       ./redirect.sh 2210 2200

目的:  client --> :sport --> :dport

test:
$ ./redirect.sh 2210 2200

$ nc -vz 192.168.101.18 2210
    Connection to 192.168.101.18 2210 port [tcp/*] succeeded!

$ nc -vz 127.0.0.1 2210
    Connection to 127.0.0.1 2210 port [tcp/*] succeeded!

_EOF_
function redirect_local2local()
{
   sport=$1
   dport=$2
   
   echo 1 > /proc/sys/net/ipv4/ip_forward
   iptables -t nat -A OUTPUT -p tcp --dport $sport -j DNAT --to-destination :$dport
   iptables -A INPUT -p tcp --dport $sport -j ACCEPT
}

redirect_local2local $1 $2
```
