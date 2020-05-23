#1)build
#  docker build -t myubuntu:19.04 ./
#
#2)create
# Centos: /usr/sbin/init Ubuntu: /sbin/init
#
# dname=gitlab; ip=172.18.0.108; 
# docker run -it -d \
#     --name $dname \
#     --net=dockernet \
#     --ip=$ip \
#     -v data=/data/docker/disks/gitlab/data \
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
#3)run
#  dockerin
#或
# docker exec -it gitlab /bin/bash

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y upgrade && \
apt-get -y install apt-utils cron openssl \
   openssh-server net-tools git \
   locales vim curl wget dnsutils iputils-ping \
   iproute2 telnet netcat elinks whois dbus rsyslog language-pack-en-base nmap & \
#
#
echo '#!/bin/bash' > /usr/local/bin/init.sh && \
#
#
echo '[ -d /data ] || mkdir /data' >> /usr/local/bin/init.sh && \
#
#
echo '[ -f /data/init.sh ] || echo "#!/bin/bash\\n[ -f /etc/init.d/cron ] && /etc/init.d/cron start\\n[ -f /etc/init.d/ssh ] && /etc/init.d/ssh start" > /data/init.sh' >> /usr/local/bin/init.sh && \
echo 'chmod +x /data/init.sh' >> /usr/local/bin/init.sh && \
echo '/data/init.sh' >> /usr/local/bin/init.sh && \
#
#
echo '/bin/bash' >> /usr/local/bin/init.sh && chmod +x /usr/local/bin/init.sh && \
#
locale-gen en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENTRYPOINT ["/usr/local/bin/init.sh"]
