#!/bin/bash
# * * * * * /data/docker/docker.sh

for c in $(/usr/bin/docker ps | awk 'NR>1 {print $1}')
do
   /usr/bin/docker container exec $c /data/init.sh
   sleep 2
done
