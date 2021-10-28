**Android应用**
```
apt update
apt full-upgrade
wget http://archive.ubuntukylin.com/ubuntukylin/pool/main/k/kylin-software-keyring/kylin-software-keyring_2021.04.21_all.deb
dpkg -i kylin-software-keyring_2021.04.21_all.deb
apt install linux-headers-`uname -r`
apt install containerd
apt install docker.io
apt install kmre kmre-apk-installer
reboot
```
