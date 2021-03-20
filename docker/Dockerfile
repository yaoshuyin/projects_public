:<<_EOF_
#0)sys_admin / systemd / init / rc.local

#1)build
 docker build -t harbor.a.com:9443/myimgs/myubuntu:20.04 .
#Or
 docker build -t myimgs/myubuntu:20.04 . 
 docker tag myimgs/myubuntu:20.04 harbor.a.com:9443/myimgs/myubuntu:20.04

 docker push harbor.a.com:9443/myimgs/myubuntu:20.04
 docker pull harbor.a.com:9443/myimgs/myubuntu:20.04

#2)create
# Centos: /usr/sbin/init Ubuntu: /sbin/init

 sysopts=" --privileged=true --cap-add=SYS_ADMIN -v /run -v /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro --security-opt seccomp=unconfined "

 docker run $sysopts -it -d --name test -h test --restart=always -v /data/docker/disks/test/data:/data harbor.a.com:9443/myimgs/myubuntu:20.04 /usr/sbin/init

 docker network create -d bridge --subnet 172.18.0.0/24 dockernet

 dname=gitlab; ip=172.18.0.108; data=~/data/docker/disks/spiders_data;
 docker run $sysopts -d --name $dname -h $dname --restart=always \ 
     -v "$data:/data" -w /data \
     --net=dockernet --ip=$ip \
     ubuntu:16.04 /sbin/init

 cname=testtmp; ip=172.18.0.111; data=~/data/docker/disks/testtmp_data;
 docker run $sysopts -it -d --ip=$ip --net=dockernet \
   -v "$data:/data" -w /data -h $cname --name $cname \
   --restart=always myubuntu:20.04 /bin/bash

 docker run $sysopts -it -d --ip=192.168.65.10 -p 2222:22 -p 8001:8001 -v "/data/docker/gitlab:/data" -w /data -h gitlab --name gitlab --restart=always myubuntu20.04 /bin/bash

#3)run
  dockerin
#或
 docker exec -it gitlab /bin/bash

#4)Other
#
# access docker host: curl http://host.docker.internal
_EOF_

FROM ubuntu:20.04
MAINTAINER cnscn cnscn@sina.com
ENV DEBIAN_FRONTEND noninteractive

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
#
#apt sources.list
    && codename=$(grep DISTRIB_CODENAME /etc/lsb-release| awk -F = '{print $2}') && echo $codename  \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} main restricted  > /etc/apt/sources.list  \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates main restricted >> /etc/apt/sources.list  \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} universe >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates universe >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} multiverse >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates multiverse >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-backports main restricted universe multiverse >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security main restricted >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security universe >> /etc/apt/sources.list \
    && echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security multiverse >> /etc/apt/sources.list \
    && apt -y clean && apt -y update && apt-get -y upgrade \
#
#init apps
    && apt -y install apt-utils dialog cron openssl openssh-server net-tools git vim curl wget dnsutils iputils-ping iproute2 telnet netcat elinks whois nmap locales tzdata sudo \
    && locale-gen en_US.UTF-8 && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata  \
#
#rc.local
    && ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service  \
    && echo "[Install]\\nWantedBy=multi-user.target\\nAlias=rc-local.service" >> /etc/systemd/system/rc-local.service \
    && echo "#!/bin/bash\\n" > /etc/rc.local && chmod +x /etc/rc.local \
#
#/data/init.sh
    && echo "test -d /data || mkdir /data\\ntest -f /data/init.sh || echo '#!/bin/bash' >/data/init.sh\\nchmod +x /data/init.sh\\n/data/init.sh" >> /etc/rc.local

#ENV
ENV LC_ALL=en_US.UTF-8

#ENTRY
CMD ["/usr/sbin/init"]
