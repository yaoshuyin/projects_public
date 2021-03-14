
```
.内核版本
3.14.9
3  内核主版本
14 偶数表示稳定版本，奇数表示开发中版本
9  修改的数

.swap
swap分区没有挂载点
大小通常为内存的2倍
当物理内存不足时，系统会将内存中不常用的数据放到SWAP中，即SWAP此时被当作了虚拟内存

.NetInstall源
http://mirrors.163.com/centos7/os/x86_64/

.启动级别
0 关机
1 单用户模式
3 完整的多用户模式
5 图形桌面
6 重新启动

.TCP/IP
1) 网络接口层  物理层／数据链路层 :
    接口＋链路控制
2) 网际互联层  网络层             :
    主机到主机间的通信, IP/ARP/RARP/ICMP
3) 传输层      传输层:
    为应用层提供端到端的通信功能
    提供流量控制、确保数据完整、正确
    TCP
    UDP
4) 应用层      会话层／表示层／应用层

5) 包
   TCP／IP 称为 帧
   IP层    称为 IP数据报
   TCP层   称为 TCP报文

6)
   版本      1   0－0
   长度      4   1-4
   服务类型  8   5－12
   总长度        16-31

.ping
 -f 极限检测，快速大量给目标主机发包
 -R 记录路由过程
 -c 只发指定的包数
 -i 间隔几秒发一包
 -I 使用指定的网络界面发送数据包
 -t 设置存活数据TTL的大小

.ifconfig
 ifconfig en0 192.168.0.100/24 up

.route
 route -n
 route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.0.1
 route del -net 192.168.1.0 netmask 255.255.255.0
 route add default gw 192.168.0.1

.rsync
 -c 对文件传输进行校验
 -a 归档模式，以递归方式传输文件，并保持文件属性，等于-rlptgoD
 -r 递归模式
 -R 使用相对路径
 -p 保持文件权限
 -o 保持文件属主
 -g 保持文件属组
 -t 保持文件时间信息
 -n 现实哪些文件将被传输
 -W 复制文件，不进行增量检测
 -e 使用rsh、ssh方式进行数据同步
 --delete  删除DST中SRC没有的文件
 -z 传输时压缩
 --exclude=PATTERN  排除文件模式
 --include=PATTERN  需要传输的文件模式
 --exclude-from=FILE    不传输FILE内的文件
 --include-from=FILE    传输的FILE内的文件
 --progress             在传输时显示传输过程
 --port 56789

 rsync -avz --port 56789 a.txt root@a.com::backup/tmp/a.txt

.netstat 
 -r 显示路由表

.traceroute
 -i 指定网卡
 -I 使用ICMP回应取代UDP
 -n 使用IP地址，而非主机名
 -p 设置UDP端口
 -r 忽略路由表，直接发包到远程主机
 -s 设置本地主机送出数据包的IP地址

.wget
 -nc 不覆盖现有文件
 -c  断点续传
 -N  只下载更新的文件

.iptables
1) table
   nat:
     PREROUTING
     POSTROUTING

   mangle（应用可在此规则表里设定，如数据包做标记）
      PREROUTING
      FORWARD
      POSTROUTING

   filter: 是默认规则表
     chain:
      INPUT
      FORWARD
      OUTPUT
    动作:
      ACCEPT
      DROP
      REJECT
      LOG

0) SNAT 源地址转换
   DNAT 目的地址转换

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t filter -A FORWARD -s 192.168.19.0/24 -j DROP
入包:
包--> eth0-->
 mangle PREROUTING (对包进行改写或做标记) -->
 nat PREROUTING (主要做DNAT) -->
 路由判断 (包是发往本地还是用来转发的) -->
 mangle INPUT (路由后，被送往本地程序前对包进行改写或做标记) -->
 filter INPUT (以本地为目的的包都要经过此链) -->
 本地服务程序


.出包
程序 -->
  路由判断 -->
  mangle OUTPUT (对包进行改写或做标记) -->
  nat OUTPUT (对发出的包进行DNAT操作) -->
  filter OUTPUT (对本地发出的包过滤) -->
  mangle POSTROUTING (进行包修改) -->
  filter POSTROUTING (做SNAT) -->
  离开网口

.转发的包
数据包在链路上传输 -->
进入网络接口 -->
mangle PREROUTING (对包进行改写或做标记) -->
nat PREROUTING (做DNAT) -->
路由判断(发往本地还是转发) -->
mangle FORWARD (特殊情况才会被用到,在最初的路由判断后，在最后一次更改包的目的之前) -->
filter FORWARD (所有要转发的包都会经过这里,针对包的过滤也在这里进行) -->
mangle POSTROUTING (在所有更改包的目的地址的操作完成之后做的，但这时包还在本地) -->
nat POSTROUTING (此链用来做SNAT,不推荐在此做过滤,因为某些包即使不满足条件也会通过) -->
离开网络接口


-F 删除规则链的所有规则
-Z 将数据包计数器归零
-N 定义新的规则链
-X 删除某个规则链
-P 默认处理方式

--sport  匹配包的源端口
--dport  匹配包的目的端口
--tcp-flags 匹配数据包的状态标志,SYN/ACK/FIN/ALL/NONE
-m 匹配不连续的多个源端口或目的端口

REDIRECT  将数据包定向另一个端口
LOG       将数据包相关信息记录在log
SNAT      改写数据包来源IP为某特定IP或IP范围
DNAT      改写数据包目的地IP为某IP
RETURN    结束在目前规则链中的过滤程序
MARK      数据包做标记

.允许来自192.168.3.0/24访问本机sshd服务
iptables -A INPUT -p tcp -s 192.168.3.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

iptables -A INPUT -p tcp -s 192.168.3.0/24 --dport 22 -j ACCEPT

iptables -t filter -A FORWARD -p tcp -i eth0 -o eth1 --dport 80 -j ACCEPT



.SNAT
  通常为了使用私网地址能访问外网
  只能在POSTROUTING上进行

 DNAT
  指修改包的目标地址,端口转发、负载均衡和透明代理
  只能在PREROUTING内进行

 #改变源地址为1.2.3.4
 iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 1.2.3.4

 iptables -t nat -A PREROUTING -p tcp -i eth2 -d 1.2.3.4 --dport 80 -j DNAT --to 192.168.3.88:80

 入包：包 --> eth0 --> DNAT(PREROUTING) --> Routing --> mangle INPUT --> filter INPUT --> 程序

 出包：
   程序 -->
    路由判断 -->
    mangle OUTPUT -->
    nat OUTPUT (SNAT) -->
    filter OUTPUT -->
    mangle POSTROUTING -->
    filter POSTROUTING -->
    离开网口

.SNAT 出去的时候改变源地址为 网关地址
 DNAT 进来的时候改变目的地址或端口，比如访问的是80，但真正服务的是8888
```

**本机端口8888 转发到本机80**
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

**本机端口9974转发到其它主机的80**

```bash
:<<_EOF_
Author: cnscn
Script: redirect.sh
功能:   本机端口 重定向到 其他服务器端口
        !!!nc -vz 127.0.0.1:8888 是无法访问的，只能lo以外的IP才可以
环境:
  本机IP:    172.18.0.9
  dest_host: 172.18.0.100

  目的:      client --> 172.18.0.9:8888 --> 172.18.0.100:80
             client --> 172.18.0.9:2222 --> 172.18.0.100:22

Usage: ./redirect.sh server_eth server_port  dest_host dest_port
       ./redirect.sh eth0 8888 172.18.0.100 80
       ./redirect.sh eth0 2222 192.168.0.100 22

test:
  $ redirect eth0 8888 172.18.0.100 80
  $ nc -vz 172.18.0.9 8888
    Connection to 172.18.0.9 8888 port [tcp/*] succeeded!
  
  $ nc -vz -w 2 127.0.0.1 8888
  nc: connect to 127.0.0.1 port 8888 (tcp) timed out
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
}

redirect_local2remote $1 $2 $3 $4
```

```
.ip
 ip addr list
 ip addr add 192.168.0.3/24 dev eth0
 ip addr del 192.168.0.3/24 dev eth0

 ip route list
 ip route add 192.168.3.1 dev eth0

.tcpdump
 -i eth0
 host net port
 src dst or and
 not ! and && or ||
 S SYN
 F FIN
 P PUSH
 R RST

 tcpdump -i eth0
 tcpdump -i eth0 tcp and dst host 192.168.0.1 and dst port 3306 -s100 -XX -n

.dhcp server
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

.route
RIP:
  Routing Information Protocol
  路由信息协议
  以30秒为周期向相邻的路由器交换信息，从而让每个路由器都建立路由表
  通过一个路由器称为一跳
  跳数超过15数据包将不可达
  因每30秒向相邻路由器交换信息，因此收敛时间(路由协议让每个路由器建立精确并稳定的路由表的时间长度，时间越长，网络发生变化后，路由表生成的越慢，网络稳定需要的时间也越长)相对较长

OSPF(Open Shortest path First, 开放最短路径优先)
  一般用于一个路由域内，称为自治系统(Autonomous System)
  根据链路状态计算路由表
  适合大型网络
  收敛速度更快

BGP(Border Gateway Protocol)
  边界网关协议
  用来处理自治系统之间的路由关系的路由协议
  适合处理Internet这样巨大的网络
  使用通路向量路由协议
  使用TCP协议进行可靠的传输
  使用了路由汇聚、增量更新等功能
  极大增加网络可靠性和稳定性

IGRP
  Interior Gateway Routing Protocol
  内部网关路由协议
  是距离向量路由协议
  要求路由器以90秒为周期向相邻的路由器发送路由表的全部或部分
  由此区域内的路由器都可以计算出所有网络的距离
  由于使用网络延迟、带宽、可靠性及负载用作路由选择，因此稳定性相当不错

.route add|del -net|-host ip netmask mask gw ip|dev

route add default gw 192.168.0.168.0.1

route add -net 192.168.1.0/24 gw 192.168.0.1
route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.0.1

.两个内网 分别走两条 InternetLine
192.168.1.1 eth0           eth2 172.16.1.1 ... InternetLineA
                    HOST                      
192.168.2.1 eth1           eth3 172.16.2.1 ... InternetLineB

```
![avatar](pic/internetline.png.png)

```Console
echo 199 InternetLine1 >> /etc/iproute2/rt_tables
echo 200 InternetLine2 >> /etc/iproute2/rt_tables

ip rule add from 192.168.101.0/24 table InternetLine1
ip route add default via 172.16.1.1 table InternetLine1

ip rule add from 192.168.102.0/24 table InternetLine2
ip route add default via 172.16.2.1 table InternetLine2

ip route list table InternetLine1
   default via 172.18.0.1 dev eth0 
ip route list table InternetLine2
   default via 172.18.0.1 dev eth0 
```

**MySQL**
```mysql
mysql> set password=password('123456');

mysqladmin
mysqlcheck
mysqldump
mysqlimport
mysqlshow
mysqldumpslow
mysqlbinlog

bind-address
port
socket
datadir
tmpdir
skip-external-locking
back_log 在连接请求等待队列中允许存放的最大连接数
character-set-server 默认字符集
key_buffer_size myisam索引缓冲区
max_connections 允许的最大连接数
table_cache 设置表调整缓存的数量
max_allowed_packet 网络传输中，一次消息传输量的最大值
binlog_cache_size 在事务过程中容纳二进制日志SQL语句的缓存大小
sort_buffer_size 用来完成排序操作的线程使用的缓冲区大小
join_buffer_size 为两个表间的每个完全连接分配连接缓冲区
thread_cache_size 线程缓冲区所能容纳的最大线程个数
thread_concurrency 限制一次有多少线程能进入内存

query_cache_size 为缓存查询结果分配的内存的数量
query_cache_limit 如查询结果超过此参数设置的大小将不进行缓存
ft_min_word_len  加入索引的词的最小长度
thread_stack 每个连接创建时分配的内存
transaction_isolation mysql数据库事务隔离级别
tmp_table_size 临时表的最大大小
net_buffer_length 服务器和客户之间通信使用的缓冲区长度
read_buffer_size 对数据表顺序读取时分配的MySQL读入缓冲区大小
read_rnd_buffer_size MYSQL随机读缓冲区大小
max_heap_table_size HEAP表允许的最大值
default-storage-engine
log-bin
server-id
slow_query_log
long_query_time
log-queries-not-using-indexes
expire-logs-days
replicate_wild_ignore_table 主从同步时忽略的表
replicate_wild_do_table 主从同步时需要同步的表
innodb_data_home_dir  InnoDB数据文件的目录
innodb_file_per_table 启用独立表空间
innodb_data_file_path InnoDB数据文件位置
innodb_log_group_home_dir 用来存放InnoDB日志文件的目录路径
innodb_additional_mem_pool_size InnoDB存储的数据目录信息和其他内部数据结构的内存池大小
innodb_buffer_pool_size Innodb存储引擎的表数据和索引数据的最大内存缓冲区大小
innodb_file_io_threads I/O操作的最大线程个数
innodb_thread_concurrency Innodb并发线程数
innodb_flush_log_at_trx_commit Innodb日志提交方式
innodb_log_buffer_size InnoDB日志缓冲区大小
innodb_log_file_size InnoDB日志文件大小
innodb_log_files_in_group Innodb日志个数
innodb_max_dirty_pages_pct 当内存中的脏页量达到innodb_buffer_pool大小的比例时，刷新脏页到磁盘
innodb_lock_wait_timeout innodb行锁导致的死锁等待时间
slave_compressed_protocol 主从同步时是否采用压缩传输binlog

skip-name-resolve 跳过域名解析

.
create
drop
grant option
references
alter
delete
indexe
insert
select
update
create view
show view
alter routine
create routine
execute
file
create temporary table
lock tables 
crete user
process
reload
replication client
replication slave
show databases
shutdown
super

select * from tables_priv where user='user1';

show grants for user1@1.1.1.1

revoke insert on *.* from 'u'@'%';
revoke all on *.* from 'u'@'%';
drop user 'u'@'%';
mysqlbinlog mysql-bin.000005 | cat -n
purge binary logs to 'mysql-bin.010';
purge binary logs before '2015-04-02 22:46:26';
set global expire_logs_days=7;

slow_query_log = 1
long_query_time = 1
log-slow-queries = /tmp/slow.log
#log-queries-not-using-indexes

mysqldump -u root -d --add-drop-table test > test.sql
mysql -uroot test < a.sql

-A 导出全部数据库
--add-drop-database
--add-drop-table
--add-locks
-c 导出时使用完整的insert语句
--default-character-set 设置默认字符集
-x 提交请求，锁定所有表，保证数据一致
-l 导出前，锁定所有表
-n 只导出数据，而不添加create database语句
-t 只导出数据，而不添加create table
-d 只导出数据结构，不导出数据
-w 只导出给定的where条件选择的记录

.xtrabackup
因mysqldump备份和恢复时间会较长
xtrabackup 是一款高效的备份工具，备份时不会影响原数据库的正常更新

./innobackupex --defaults-file=/etc/my.cnf --socket=/data/mysql_data/mysql.sock --user=root --password=123456 --slave-info /data/backup

mysql -S /tmp/mysql.sock -u root -p

grant replication slave on *.* to repl@'192.168.1.%';

change master to master_host='192.168.1.100', master_port=3306, master_user='repl', master_password='';

.nginx
upstream up{
ip_hash;
  server 1.1.1.1:8000 weight=2 max_fails=1 fail_timeout=10s;
server 1.1.1.2:8000 weight=1 max_fails=1 fail_timeout=10s;
}

.
proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
client_max_body_size 10m;
client_body_buffer_size 128k;
proxy_connect_timeout 3;
proxy_send_timeout 3;
proxy_read_timeout 3;
proxy_buffer_size 32k;
proxy_buffers 4 32k;
proxy_busy_buffers_size 64k;
proxy_temp_file_write_size 64k;
proxy_next_upstream error timeout http_500 http_502 http_503 http_504;

location ~* ^.+\.(js|css)$ {
   root /data/a;
   expires 2d;
   access_log /var/log/a.log main;
}

location ~ \.php$ {
   fastcgi_pass 127.0.0.1:9000;
   fastcgi_index index.php;
   fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
   include fastcgi_params;
}

.集群
 数据链路层，可以根据数据包的MAC地址选择不同的路径
 网络层可以利用IP地址的分配方式将数据分配到多个节点
 LVS linux virtual server
 基于IP层和内容 分发的负载平衡调度解决方案
 前端有一个负载均衡器Load Balancer

 VS/NAT Virtual Server Via Network Address Translation
 负载均衡器通过重写请求报文的目的地址实现网络地址转换，根据设定的负载均衡算法将请求分配给后端的真实服务器
  真实服务器的响应报文通过负载均衡器时，报文的源地址被重写，然后返回给客户端
  因每次请求都要经过负载均衡器，负载均衡器可能成为性能瓶颈

 VS/TUN Virtual Server via IP Tunneling
  负载均衡器把请求报文通过IP隧道发到真实服务器， 真实服务器将响应直接返回给客户，由此负载均衡器只处理请求报文，而结果不需要经过负载均衡器，因此吞吐能力更强大
  TUN模式可以支持跨网段，并支持跨地域部署

VS/DR Virtual Server via Direct Routing
 此模式通过改写请求报文的MAC地址，把请求发送到真实服务器，DR模式下真实服务器把响应直接返回给客户端
 此方式要求负载均衡器与真实服务器都在同一物理网段上
 此方式没有IP隧道的开销

.负载均衡高度算法
 轮询RR: Round Robin 
 加权轮询WRR: Weighted Round Robin
     负载均衡器可以自动问询后端服务器的负载情况，并动态调整其权值

最少链接算法LC: Least Connections
加权最少链接算法WLC: Weighted Least Connections

虚拟IP     192.168.32.100 
负载均衡器 192.168.32.101 / 102
后端服务器 192.168.32 104 / 105

ipvsadm 是LVS主程序，负责RS的添加、删除、修改
ipvsadm-save 备份LVS配置
ipvsadm-restore 用于恢复LVS配置

-A 在内核的虚拟服务器表中添加一条新的虚拟服务器记录
-E 编辑内核虚拟服务器表中的一条虚拟服务器记录
-D 删除内核虚拟服务器中的一条虚拟服务器记录
-C 清除内核虚拟服务器表中的所有记录
-R 恢复虚拟服务器规则
-S 保存虚拟服务器规则，输出为－R选项可读的格式
-a 在内核虚拟服务器表的一条记录里添加一条新的真实服务器记录
-e 编辑一条虚拟服务器记录中的某条真实服务器记录
-d 删除一条虚拟服务器记录中的某条真实服务器记录

.配置
!!! vip/ld/rs 在同一网段

1)架构:
  vip: 192.168.56.110
    ld1: eth0 192.168.56.101  eth0:0 192.168.56.110
    ld2: eth0 192.168.56.102  eth0:0 192.168.56.110

  rs1: 192.168.56.103
  rs2: 192.168.56.104

2)load balancer
a) ld1 eth0 192.168.56.101

echo >> /etc/rc.local <<EOF
  echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/ipvsadm -A -t 192.168.56.110:80 -s wrr
  /usr/sbin/ipvsadm -a -t 192.168.56.110:80 -r 192.168.56.103:80 -m -w 1
  /usr/sbin/ipvsadm -a -t 192.168.56.110:80 -r 192.168.56.104:80 -m -w 1
EOF

b) ld1 eth0 192.168.56.102

echo >> /etc/rc.local <<EOF
  echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/ipvsadm -A -t 192.168.56.110:80 -s wrr
  /usr/sbin/ipvsadm -a -t 192.168.56.110:80 -r 192.168.56.103:80 -m -w 1
  /usr/sbin/ipvsadm -a -t 192.168.56.110:80 -r 192.168.56.104:80 -m -w 1
EOF

3)real server
  a) rs1 eth0 192.168.56.103
     apt install nginx
     echo 56.103 > /var/www/html/index.nginx-debian.html 
  
  2) rs2 eth0 192.168.56.104
     apt install nginx
     echo 56.104 > /var/www/html/index.nginx-debian.html 
  
4)test
$ curl http://192.168.56.110
   56.103
   
$ curl http://192.168.56.110
   56.104
   
$ curl http://192.168.56.110
   56.103
