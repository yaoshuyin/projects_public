**install the newest gcc**
```bash
$ yum install -y centos-release-scl 
$ yum install -y devtoolset-7-gcc devtoolset-7-gcc-c++
$ scl enable devtoolset-7 bash 
$ gcc -v
```

**install tcl 8.6.11(一定要用8.6.11或以后，否则make test报xxx.tcl错误)** 
```bash
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
