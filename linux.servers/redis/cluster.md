**Server/Ports**
```
OS: CentOS Linux release 7.9.2009 (Core)
Ports: 7000 7001 7002 7003 7004 7005
```

**install the newest gcc**
```bash
$ yum install -y centos-release-scl 
$ yum install -y devtoolset-7-gcc devtoolset-7-gcc-c++
$ scl enable devtoolset-7 bash 
$ gcc -v
```

**install tcl 8.5(一定要用8.5或以后)** 
```bash
$ yum install -y tcl tcl-devel

OR

$ wget -c https://nchc.dl.sourceforge.net/project/tcl/Tcl/8.6.11/tcl8.6.11-src.tar.gz
$ tar xvf tcl8.6.11-src.tar.gz
$ cd tcl8.6.11
$ ./configure
$ make
$ make install
```

**download redis**
```bash
$ wget https://download.redis.io/releases/redis-6.0.10.tar.gz
$ tar xvf redis-6.0.10.tar.gz
$ cd redis-6.0.10

$ cd deps
$ make lua hiredis linenoise jemalloc
$ cd ..

$ make CFLAGS="-march=x86-64"
$ make test
Execution time of different units:
  0 seconds - unit/printver
  35 seconds - unit/dump
  ....
  0 seconds - unit/shutdown
  294 seconds - defrag

\o/ All tests passed without errors!

Cleanup: may take some time... OK
$ make install
```

**配置集群**
```
#创建目录
$ mkdir -p /data/redis/700{0..5}

#创建配置文件
$ for i in {0..5}
do
   cat > /data/redis/700${i}/redis.conf <<_EOF_
daemonize yes
port 700${i}

masterauth 123456
requirepass 123456

dir "/data/redis/700${i}" 
pidfile "/data/redis/700${i}/redis.pid"
logfile "/data/redis/700${i}/redis.log"

cluster-enabled yes
#nodes.conf is simply generated at startup by the Redis Cluster instances, and updated
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
_EOF_
done

#启动redis
$ for i in {0..5}
do 
   /usr/local/bin/redis-server /data/redis/700${i}/redis.conf 
done

#创建集群
# --cluster-replicas 1  指每个master需要一个slave
# 这里一共6个server, 所以分成3个master和3个slave
$ redis-cli -a 123456 --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1

#reshard
$ redis-cli --cluster reshard 127.0.0.1:7000
    How many slots do you want to move (from 1 to 16384)? 1000
    From what nodes you want to take those keys? all
    
$ redis-cli --cluster check 127.0.0.1:7000
```

**redis.service**
```
for i in {0..5}
do 
cat > /usr/lib/systemd/system/redis700${i}.service <<_EOF_
[Unit]
Description=Redis persistent key-value database
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/data/redis/700${i}/redis.pid
ExecStart=/usr/local/bin/redis-server /data/redis/700${i}/redis.conf --supervised systemd
ExecStop=/usr/local/bin/redis-cli -a 123456 -h 127.0.0.1 -p 700${i} shutdown   #/usr/bin/kill -s QUIT $MAINPID 
ExecReload=/usr/bin/kill -s HUP $MAINPID
User=root
Group=root
RuntimeDirectory=redis
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
_EOF_

systemctl enable redis700${i}
systemctl start  redis700${i}
systemctl stop   redis700${i}
systemctl reload redis700${i}
systemctl status redis700${i}
done
```

**测试**
```
[root@mha-manager tmp]# redis-cli -c -a 123456  -h 127.0.0.1 -p 7000
127.0.0.1:7000> get bar
-> Redirected to slot [5061] located at 127.0.0.1:7003
(nil)

127.0.0.1:7003> set bar 123
OK

127.0.0.1:7003> get bar
"123"

127.0.0.1:7003> set name tom
OK

127.0.0.1:7003> get name
"tom"

127.0.0.1:7003> cluster info
cluster_state:ok
cluster_slots_assigned:16384
...
cluster_stats_messages_received:1279

127.0.0.1:7003> cluster nodes
b3cc8c9....c1924 127.0.0.1:7003@17003 myself,master - 0 1612541279000 8 connected 0-5961 10923-11421

81e45988...4d69a 127.0.0.1:7005@17005 master - 0 1612541281528 10 connected 11422-16383
3210028e...9eaad 127.0.0.1:7004@17004 master - 0 1612541281124 9 connected 5962-10922

29520ece...4adee 127.0.0.1:7002@17002 slave 81e459...9a 0 1612541280000 10 connected
a4f5ebb0...8e9c4 127.0.0.1:7001@17001 slave 321002...ad 0 1612541281000 9 connected
a2e1113d...1c834 127.0.0.1:7000@17000 slave b3cc8c...24 0 1612541279509 8 connected
127.0.0.1:7003> 

[root@mha-manager tmp]# redis-cli -c  -h 127.0.0.1 -p 7000
127.0.0.1:7000> get bar
(error) NOAUTH Authentication required.

127.0.0.1:7000> auth 123456
OK

127.0.0.1:7000> get bar
-> Redirected to slot [5061] located at 127.0.0.1:7003
(error) NOAUTH Authentication required.

127.0.0.1:7003> auth 123456
OK

127.0.0.1:7003> get bar
"123"

127.0.0.1:7003> get name
"tom"
```

**节点操作**
```
$ redis-cli --cluster reshard <host>:<port> --cluster-from <node-id> --cluster-to <node-id> --cluster-slots <number of slots> --cluster-yes

$  redis-cli -p 7000 cluster nodes | grep master
$  redis-cli -p 7000 cluster nodes | grep slave

$ redis-cli --cluster add-node 新节点 任意一个已经存在的节点
  redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000 
  
$ redis-cli --cluster add-node 新节点 任意一个已经存在的节点  --cluster-slave指定新节点作为任意master的slave
  redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000  --cluster-slave
  
# 指定 新节点 为 指定master-id的slave节点  
$ redis-cli --cluster add-node 新节点 任意一个已经存在的节点 --cluster-slave --cluster-master-id master-id
  redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000 --cluster-slave --cluster-master-id 3c3a0c74aae0b56170ccb03a76b60cfe7dc1912e
  
$ redis-cli --cluster del-node 任意一个已经存在的节点  `要删除的节点的ID`
  redis-cli --cluster del-node 127.0.0.1:7000 `<node-id>`
```
