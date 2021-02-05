**install the newest gcc**
```bash
$ yum install gcc gcc-c++
$ yum install centos-release-scl 
$ yum install devtoolset-7-gcc devtoolset-7-gcc-c++
$ scl enable devtoolset-7 bash 
$ gcc -v
```

**download redis**
```bash
$ wget https://download.redis.io/releases/redis-6.0.10.tar.gz
$ tar xvf redis-6.0.10.tar.gz
$ cd redis-6.0.10

$ cd deps
$ make lua hiredis linenoise jemalloc
$ cd ..

$ cd deps/jemalloc
$ ./configure 
$ make

$ make CFLAGS="-march=x86-64"
$ make test
```
