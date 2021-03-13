**模块**
- 镜像
- 容器
- 数据巻
- 网络

**特点**
- 部署时间短

```console
docker run -d -p 80:80 --name web nginx
docker pull ubuntu
docker pull openresty/openresty:1.9.15.1-centos
docker search php
docker images
docker images ph*
docker inspect nginx:1.10
docker rmi php:5.6

docker save centos:7 > centos-7.tar
docker save centos:7 -o centos-7.tar

docker load -i centos-7.tar
docker load < centos-7.tar

docker login
docker login -u user server
docker login -u user -p passwd server

docker push user/imagename:tag

docker push localhost:5000/user/imagename:tag

docker commit ContainerNameOrID
docker images

"导出容器及所有层数据到镜像中
docker export ContainerNameOrID > a.tar
docker export ContainerNameOrID -o a.tar

docker import a.tar
docker import a.tar a:latest
docker images

.docker save与export
docker save:
导出镜像到tar,如果指定的是容器名也只是导出容器背后的镜像image

docker export:
导出运行中的容器及其中的数据到镜像文件


```

**docker save && export**
```console
$ docker save centos > centos.tar
$ ls -lh
  ... 202M ... centos.tar

$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
centos       7         8652b9f0cb4c   3 months ago   204MB

$ docker load < centos.tar 
Loaded image: centos:7

$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
centos       7         8652b9f0cb4c   3 months ago   204MB

$ docker export centos > centos-import.tar

$ ls -lh
... 2.6G centos-import.tar
... 202M centos.tar

$ docker import centos-import.tar centos-import

$ docker images
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
centos-import   latest    d7ac01197037   3 seconds ago   2.72GB
centos          7         8652b9f0cb4c   3 months ago    204MB

$ docker run -d -it --name centos-save centos:7 /bin/bash
$ docker run -d -it --name centos-import centos-import:latest /bin/bash

$ dockerin
1) centos-import(172.17.0.3)  3) centos(172.18.0.8)
2) centos-save(172.17.0.2)

#import后，保留了容器的数据(不包括独立挂载的巻)
[root@centos-import /]# cd 
[root@7ef37ea703ee ~]# ls
15:26:40  zabbix 20212611 

#load后的镜像没有容器运行时的数据，是空的
[root@docker-save /]# cd
[root@0a54b6c54d83 ~]# ls
anaconda-ks.cfg


```

**docker volume**
```console
$ docker volume create --name vol_test
vol_test

$ docker volume list
DRIVER    VOLUME NAME
local     vol_test

$ docker volume inspect vol_test
[
    {
        "CreatedAt": "2021-03-11T23:58:33+08:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/vol_test/_data",
        "Name": "vol_test",
        "Options": {},
        "Scope": "local"
    }
]

$ docker run -d -i -t --name test -v vol_test:/data centos:7 /bin/bash

```

**数据巻容器**
```
创建一个容器时创建数据巻(容器无需运行)
$ docker create --name c_data -v /data centos:7
$ docker inspect c_data
  ...
  "Mounts": [
     {
        "Type": "volume",
        "Name": "a14d66543e64...629270231ff0",
        "Source": "/var/lib/docker/volumes/a14d66...9270231ff0/_data",
        "Destination": "/data",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
     }
  ]

# 源及挂载点 会使用 c_data容器创建时的 源及挂载点
$ docker run -d -it --name centos_vol_from_data --volumes-from c_data centos:7 /bin/bash

$docker inspect centos_vol_from_data
  ...
  "Mounts": [
     {
        "Type": "volume",
        "Name": "a14d6654...4087f629270231ff0",
        "Source": "/var/lib/docker/volumes/a14d665...70231ff0/_data",
        "Destination": "/data",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
     }
  ],
  ...

$ touch /var/lib/docker/volumes/a14d66...31ff0/_data/a.txt
$ touch /var/lib/docker/volumes/a14d66...31ff0/_data/1234.txt

$ dockerin
1) centos_vol_from_data(172.17.0.4)  3) centos-save(172.17.0.2)
2) centos-import(172.17.0.3)	     4) centos2(172.18.0.8)
#? 1
[root@c27a15f0e3e3 /]# cd /data
[root@c27a15f0e3e3 data]# ls
1234.txt  a.txt
```

**docker link**
```console
#通过link后，可以通过主机名访问link的源主机

$ dockerin
1) centos_vol_from_data(172.17.0.4)
2) centos-import(172.17.0.3)
3) centos-save(172.17.0.2)
4) centos2(172.18.0.8)
#? 

$ docker run -d -it --name centos_vol_from_data2 --link centos-import:centoslink --volumes-from c_data centos:7 /bin/bash

$ dockerin
1) centos_vol_from_data2(172.17.0.5)
2) centos_vol_from_data(172.17.0.4)
3) centos-import(172.17.0.3)
4) centos-save(172.17.0.2)
5) centos2(172.18.0.8)

[root@5903c19176f8 ~]# cat /etc/hosts
172.17.0.3	centoslink 7ef37ea703ee centos-import
172.17.0.5	5903c19176f8

.安全
1)Docker只允许程序使用kill、setgid、setuid、net_bind_service、net_raw、chown等部分内核能力

-m 512M 限制最大内存为512M
--memory-swap 限制对 内存＋Swap 的总量
-m 512M --memory-swap 1024M

-c 限制容器占用CPU权重
docker run -d -c 500 nginx
docker run -d -c 1000 mysql
表示nginx与mysql对CPU的占比是1:2

--cpu-period
--cpu-quota
docker run -d --cpu-period 10000 --cpu-quota 5000 nginx:stable

--device-read-bps   限制硬盘读速度
--device-write-bps  限制硬盘写速度
--device-read-iops  限制IO数量
--device-write-iops 限制IO数量
--device-read-bps /dev/sda:50mb

$ docker run -d --ulimit cpu=1000 --name nginx nginx
$ docker exec -it nginx /bin/bash
> ulimit -t
   1000

ulimit:
  Core dump文件大小
  数据段大小
  文件句柄数
  进程栈深度
  CPU时间
  单一用户进程数
  进度虚拟内存

.--read-only  容器挂载只读文件系统
docker run it --read-only ubuntu /bin/bash

.
docker run it -v /tmp/data:/data:ro nginx

.内核能力机制Capability
 控制对系统敏感操作权限的控制，是一种细粒度的权限控制方式，只有当程序拥有对应的内核能力的操作权限时，才能进行这些操作

 可以在/proc/pid/status信息中找到对应进程的内核能力
   CapInh: 
   CapPrm:
   CapEff:
   CapBnd:

--cap-add   新建容器时添加cap
--cap-drop  新建容器时删除cap
  --cap-drop chown  删除容器内使用chown的能力

--selinux-enabled


RESTful: Representational State Transfer 表述性状态转移
```

**Docker Compose**
```console
.Docker Compose定义容器的启动方式和配置，以及不同容器间的依赖关系
.Service
 定义服务配置
 服务之间的依赖关系
.Project
 多个服务组成的业务单元

.默认存在于docker-compose.yml
.apt install docker-compose
.docker-compose
Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]

  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  bundle             Generate a Docker bundle from the Compose file
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information

.docker-compose.yml
version: '2'
service:
  db:
    image: mysql:5.7
    volumes:
      - "./.data/db:/var/lib/mysql"
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: test
      MYSQL_USER: test
      MYSQL_PASSWORD: test

  wordpress:
    build: ./wordpress
    links:
      - db
    ports:
      - "8000:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_PASSWORD: 123456
```

**挂载文件**
```console
-v ~/.bashrc:/root/.bashrc
```
