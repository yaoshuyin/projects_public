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
   cat > /data/redis/$i/redis.conf <<_EOF_
port 700${i}
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
   cd /data/redis/700${i}
   nohup /usr/local/bin/redis-server redis.conf &
done

#创建集群
# --cluster-replicas 1  指每个master需要一个slave
# 这里一共6个server, 所以分成3个master和3个slave
$ redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1

#reshard
$ redis-cli --cluster reshard 127.0.0.1:7000
    How many slots do you want to move (from 1 to 16384)? 1000
    From what nodes you want to take those keys? all
    
$ redis-cli --cluster check 127.0.0.1:7000
```

**测试**
```
$ redis-cli -c -p 7000
redis 127.0.0.1:7000> set foo bar
-> Redirected to slot [12182] located at 127.0.0.1:7002
OK

redis 127.0.0.1:7002> set hello world
-> Redirected to slot [866] located at 127.0.0.1:7000
OK

redis 127.0.0.1:7000> get foo
-> Redirected to slot [12182] located at 127.0.0.1:7002
"bar"

redis 127.0.0.1:7002> get hello
-> Redirected to slot [866] located at 127.0.0.1:7000
"world"
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
