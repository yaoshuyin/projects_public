#1)build
#
# docker build -t harbor.a.com:9443/myimgs/myubuntu:20.04 .
#Or
# docker build -t myimgs/myubuntu:20.04 . 
# docker tag myimgs/myubuntu:20.04 harbor.a.com:9443/myimgs/myubuntu:20.04
#
# docker push harbor.a.com:9443/myimgs/myubuntu:20.04
# docker pull harbor.a.com:9443/myimgs/myubuntu:20.04

#2)create
# Centos: /usr/sbin/init Ubuntu: /sbin/init
#
# dname=gitlab; ip=172.18.0.108; data=~/data/docker/disks/spiders_data;
# docker run -it -d \
#     --name $dname \
#     --net=dockernet \
#     --ip=$ip \
#     -v "$data:/data" \
#     -w /data -h $dname \
#     --restart=always \
#     --privileged=true \
#     --cap-add SYS_ADMIN \
#     --security-opt seccomp=unconfined \
#     -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
#     --tmpfs /run \
#     ubuntu:16.04 /sbin/init
#
# cname=testtmp; ip=172.18.0.111; data=~/data/docker/disks/testtmp_data;
# docker run -it -d --privileged --ip=$ip --net=dockernet \
#   -v "$data:/data" -w /data -h $cname --name $cname \
#   --restart=always myubuntu:20.04 /bin/bash
#
# docker run -it -d --privileged --ip=192.168.65.10 -p 2222:22 -p 8001:8001 -v "/data/docker/gitlab:/data" -w /data -h gitlab --name gitlab --restart=always myubuntu20.04 /bin/bash

#3)run
#  dockerin
#或
# docker exec -it gitlab /bin/bash

#4)Other
#
# access docker host: curl http://host.docker.internal

FROM ubuntu:20.04
MAINTAINER cnscn cnscn@sina.com
ENV DEBIAN_FRONTEND noninteractive

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    codename=$(grep DISTRIB_CODENAME /etc/lsb-release| awk -F = '{print $2}') && echo $codename  && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} main restricted  > /etc/apt/sources.list  && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates main restricted >> /etc/apt/sources.list  && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} universe >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates universe >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename} multiverse >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-updates multiverse >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-backports main restricted universe multiverse >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security main restricted >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security universe >> /etc/apt/sources.list && \
    echo deb http://mirrors.aliyun.com/ubuntu/ ${codename}-security multiverse >> /etc/apt/sources.list && \
#
    apt -y clean && apt -y update && apt-get -y upgrade && \
#
    apt -y install apt-utils dialog cron openssl openssh-server net-tools git vim curl wget dnsutils iputils-ping iproute2 telnet netcat elinks whois nmap locales tzdata sudo && \
    locale-gen en_US.UTF-8 && dpkg-reconfigure locales && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
#
    echo '#!/bin/bash' > /usr/local/bin/init.sh && \
    chmod +x /usr/local/bin/init.sh && \
#
    echo '[ -d /data ] || mkdir /data' >> /usr/local/bin/init.sh && \
    echo '[ -f /data/init.sh ] || echo -e "#!/bin/bash\\n/etc/init.d/cron status || /etc/init.d/cron start\\n/etc/init.d/ssh status || /etc/init.d/ssh start" > /data/init.sh' >> /usr/local/bin/init.sh && \
    echo 'chmod +x /data/init.sh && /data/init.sh' >> /usr/local/bin/init.sh && \
#
    echo '/bin/bash' >> /usr/local/bin/init.sh

ENV LC_ALL=en_US.UTF-8
ENTRYPOINT ["/usr/local/bin/init.sh"]
