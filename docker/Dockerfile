#1)build
#  docker build -t myubuntu:19.04 ./
#
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
# cname=Spiders; ip=172.18.0.11; data=~/data/docker/disks/spiders_data;
# docker run -it -d --privileged --ip=$ip --net=dockernet \
#   -v "$data:/data" -w /data -h $cname --name $cname \
#   --restart=always myubuntu:20.04 /bin/bash
#
#3)run
#  dockerin
#或
# docker exec -it gitlab /bin/bash
#
# access docker host: curl http://host.docker.internal

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update && apt-get -y upgrade && \
    apt -y install apt-utils dialog cron openssl openssh-server net-tools git vim curl wget dnsutils iputils-ping iproute2 telnet netcat elinks whois nmap locales && \
    locale-gen en_US.UTF-8 && \
#
    echo '#!/bin/bash' > /usr/local/bin/init.sh && \
    echo '[ -f /etc/init.d/cron ] && /etc/init.d/cron start' >> /usr/local/bin/init.sh && \
    echo '[ -f /etc/init.d/ssh ] && /etc/init.d/ssh start' >> /usr/local/bin/init.sh && \
    echo '[ -f /data/init.sh ] && /data/init.sh' >> /usr/local/bin/init.sh && \
#
    echo '/bin/bash' >> /usr/local/bin/init.sh && \
#
    chmod +x /usr/local/bin/init.sh

ENV LC_ALL=en_US.UTF-8
ENTRYPOINT ["/usr/local/bin/init.sh"]
