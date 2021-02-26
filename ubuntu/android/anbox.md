```
1)$ vim /etc/rc.local
/usr/bin/sudo /usr/sbin/modprobe ashmem_linux
/usr/bin/sudo /usr/sbin/modprobe binder_linux
[ -d /dev/binder ] || /usr/bin/sudo mkdir /dev/binder
/usr/bin/sudo mount -t binder binder /dev/binder
snap restart anbox.container-manager

2)
$ snap install --devmode --beta anbox

3) 
$ wget https://raw.githubusercontent.com/geeks-r-us/anbox-playstore-installer/master/install-playstore.sh
$ vim +132 install-playstore.sh
  SNAP_TOP="/snap"
  
  
$ vim +208 install-playstore.sh
#while : ;do
# if [ ! -f ./$OPENGAPPS_FILE ]; then
#        $WGET --show-progress $OPENGAPPS_URL
# else
        $WGET -q --show-progress -c $OPENGAPPS_URL
# fi
# [ $? = 0 ] && break
#done
  
$ ./install-playstore.sh
```
