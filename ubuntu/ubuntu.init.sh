      39  apt update
   40  apt upgrade
   41  apt install ntpdate 
   
   1  clear
    2  ls
    3  hostnamectl set-hostname tyo-evo-mini-demo-01
    4  su - root
    5  apt install systemd
    6  ulimit -SHn 500000
    7  grep 'LimitNOFILE=500000' /lib/systemd/system/nginx.service || { sed -i '/\[Service\]/aLimitNOFILE=500000' /lib/systemd/system/nginx.service ; systemctl daemon-reload ; /etc/init.d/nginx restart; }
    8  grep 'nofile 500000' /etc/security/limits.conf || sed -i  '/End/ i  *  -   nofile 500000' /etc/security/limits.conf
    9  grep 'session required pam_limits.so' /etc/pam.d/common-session ||  sed -i '/end of pam-auth-update/ i session required pam_limits.so' /etc/pam.d/common-session
   10  grep 'session    required   pam_limits.so' /etc/pam.d/su ||  echo  'session    required   pam_limits.so' >> /etc/pam.d/su
   11  grep 'session required /lib/security/pam_limits.so' /etc/pam.d/login ||  echo  'session required /lib/security/pam_limits.so' >> /etc/pam.d/login 
   12  grep 'ulimit -SHn 500000' /etc/profile || sed -i '$ a ulimit -SHn 500000' /etc/profile
   13  grep 'net.ipv4.tcp_tw_recycle = 1' /etc/sysctl.conf || cat >> /etc/sysctl.conf  <<_EOF_
   14  net.ipv4.tcp_tw_recycle = 1
   15  net.ipv4.tcp_tw_reuse = 1 
   16  net.ipv4.tcp_syn_retries = 2
   17  net.ipv4.tcp_synack_retries = 2
   18  net.ipv4.tcp_keepalive_time = 60
   19  net.ipv4.tcp_fin_timeout = 30
   20  net.ipv4.tcp_syncookies = 1
   21  net.ipv4.tcp_max_orphans = 262144
   22  net.ipv4.tcp_max_syn_backlog = 262144
   23  net.ipv4.tcp_timestamps = 0
   24  net.ipv4.ip_local_port_range = 1024 65000
   25  net.core.somaxconn = 262144
   26  net.core.netdev_max_backlog = 262144
   27  _EOF_
   28  vim /etc/ssh/sshd_config 
   29  /etc/init.d/ssh restart
   30  netstat -tnlp
   31  date
   32  clear
   33  date
   34  dpkg-reconfigure tzdata
   35  date
   36  ulimit -a
   37  ntpdate ntp.nc.u-tokyo.ac.jp
   38  apt install ntpdate



0 * * * * /usr/sbin/ntpdate ntp.nc.u-tokyo.ac.jp &&  /sbin/hwclock -w


root@tyo-evo-mini-demo-01:~# locale-gen 
Generating locales (this might take a while)...
  en_US.UTF-8... done
Generation complete.
root@tyo-evo-mini-demo-01:~# locale
LANG=C.UTF-8
LANGUAGE=
LC_CTYPE="C.UTF-8"
LC_NUMERIC="C.UTF-8"
LC_TIME="C.UTF-8"
LC_COLLATE="C.UTF-8"
LC_MONETARY="C.UTF-8"
LC_MESSAGES="C.UTF-8"
LC_PAPER="C.UTF-8"
LC_NAME="C.UTF-8"
LC_ADDRESS="C.UTF-8"
LC_TELEPHONE="C.UTF-8"
LC_MEASUREMENT="C.UTF-8"
LC_IDENTIFICATION="C.UTF-8"
LC_ALL=


root@tyo-evo-mini-demo-01:~# timedatectl 
                      Local time: Wed 2020-03-18 16:43:38 JST
                  Universal time: Wed 2020-03-18 07:43:38 UTC
                        RTC time: Wed 2020-03-18 07:43:38
                       Time zone: Asia/Tokyo (JST, +0900)
       System clock synchronized: yes
systemd-timesyncd.service active: yes
                 RTC in local TZ: no