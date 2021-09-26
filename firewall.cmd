```
开启端口：
$ firewall-cmd --zone=public --add-port=80/tcp --permanent 
$ firewall-cmd --add-service=mysql

关闭端口：
$ firewall-cmd --zone=public --remove-port=80/tcp --permanent 
$ firewall-cmd --remove-service=http

添加端口区间 
$ firewall-cmd --zone=public --add-port=4400-4600/tcp --permanent

将80端口的流量转发至本机8080
$ firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080

端口的流量转发其他地址
1)允许转发到其他地址
firewall-cmd –permanent –add-masquerade

2)将80端口的流量转发至192.168.1.0.1的80
firewall-cmd --add-forward-port=port=80:proto=tcp:toaddr=192.168.1.0.1

# 端口的流量转发
1)允许转发到其他地址
firewall-cmd –permanent –add-masquerade

2)将80端口的流量转发至192.168.0.1的8080端口
firewall-cmd --add-forward-port=port=80:proto=tcp:toaddr=192.168.0.1:toport=8080

设置某个ip 访问某个服务
$ firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.0.4/24" service name="http" accept"

$ firewall-cmd --permanent --zone=public --remove-rich-rule="rule family="ipv4" source address="192.168.0.4/24" service name="http" accept"
```




