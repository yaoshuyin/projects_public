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
```

