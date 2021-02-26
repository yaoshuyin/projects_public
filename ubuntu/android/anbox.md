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


$ wget https://raw.githubusercontent.com/Debyzulkarnain/anbox-bridge/master/anbox-bridge.sh
$ chmod +x anbox-bridge.sh
$ sudo ./anbox-bridge.sh stop
$ sudo ./anbox-bridge.sh start

$ snap set anbox rootfs-overlay.enable=true

$ snap set anbox bridge.address=192.168.250.1
$ snap set anbox container.netwokr.address=192.168.250.10

$ snap restart anbox.container-manager

$ sudo snap run --shell anbox.container-manager
# ls -alh /var/snap/anbox/common/combined-rootfs
$ sudo chown -R 100000:100000 /var/snap/anbox/common/rootfs-overlay


.Anbox includes Swiftshader for this which provides a high-performance CPU based implementation of OpenGL ES and EGL.
$ snap set anbox software-rendering.enable=true
$ snap restart anbox.container-manager

.If you want to disable software rendering it’s as simple as
$ snap set anbox software-rendering.enable=false
$ snap restart anbox.container-manager

打开Anbox Application Manager
 ---> webview
 --->   https://www.baidu.com
```
