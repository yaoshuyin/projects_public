apt -y install vboxconfig
apt-get -y update
apt-get -y install linux-headers-$(uname -r)
apt-get -y install build-essential linux-headers-`uname -r`
modprobe vboxdrv
