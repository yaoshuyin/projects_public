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

root@myubuntu ~# dockerin
1) centos_vol_from_data(172.17.0.4)
$ mount -l
/dev/nvme0n1p8 on /data type ext4 (rw,relatime,errors=remount-ro)

$ ls data/
a.txt

$ docker create --name c_data -v /data centos:7
$ docker inspect c_data

$ docker run -d -it --name centos_vol_from_data --volumes-from c_data centos:7 /bin/bash

$ touch /var/lib/docker/volumes/a14d66543e64b635ea3f1feecb1d5bf88fc2fb34c547ad74087f629270231ff0/_data/a.txt

$ docker inspect c_data
  ...
  "Mounts": [
     {
         "Type": "volume",
         "Name": "a14d66543e64b635ea3f1feecb1d5bf88fc2fb34c547ad74087f629270231ff0",
         "Source": "/var/lib/docker/volumes/a14d66543e64b635ea3f1feecb1d5bf88fc2fb34c547ad74087f629270231ff0/_data",
         "Destination": "/data",
         "Driver": "local",
         "Mode": "",
         "RW": true,
         "Propagation": ""
     }
  ]

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
