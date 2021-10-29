**Android应用**
```
apt -y update
apt -y full-upgrade
wget http://archive.ubuntukylin.com/ubuntukylin/pool/main/k/kylin-software-keyring/kylin-software-keyring_2021.04.21_all.deb
dpkg -i kylin-software-keyring_2021.04.21_all.deb
apt -y install linux-headers-`uname -r`
apt -y install containerd
apt -y install docker.io
apt -y install kmre kmre-apk-installer
reboot
```
