```bash
$ mkdir /tmp/easy/
$ cd /tmp/easy/

$ git clone https://aur.archlinux.org/easyconnect.git

$ cd easyconnect/
$ vim PKGBUILD   (替换成下面这些)
    source=("http://download.sangfor.com.cn/download/product/sslvpn/pkg/linux_01/EasyConnect_x64.deb"
        "http://ftp.acc.umu.se/pub/GNOME/sources/pango/1.42/pango-1.42.4.tar.xz")
    md5sums=('6ed6273f7754454f19835a456ee263e3'
          'deb171a31a3ad76342d5195a1b5bbc7c')

$ yay -S harfbuzz   cairo   pkg-config
$ makepkg --skipchecksums --install

.启动程序
$ 在开始菜单－－> 互联网 ---> EasyConnect
```
