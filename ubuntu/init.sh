.保持会话
 grep 'export TMOUT=0' ~/.bashrc || sed -i '$aexport TMOUT=0' ~/.bashrc
    
.时区设置
 dpkg-reconfigure tzdata 
   Aisa
   ShangHai

.内核优化
#!/bin/bash
grep 'net.ipv4.tcp_fin_timeout = 30' /etc/sysctl.conf || cat >> /etc/sysctl.conf  <<_EOF_
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.ip_local_port_range=3000	60999
net.ipv4.tcp_max_syn_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_max_orphans = 262144
net.core.netdev_max_backlog = 262144
_EOF_

#net.ipv4.tcp_tw_recycle = 1      #ubuntu 18 no this option,不议使用
net.ipv4.tcp_fin_timeout = 30     #default 60
net.ipv4.tcp_keepalive_time = 60  #default 7200
net.ipv4.tcp_syn_retries = 2      #default 6
net.ipv4.tcp_synack_retries = 2   #default 5
net.ipv4.tcp_tw_reuse = 1         #defalut 0
net.ipv4.tcp_timestamps = 1       #default 1,只有开启它reuse才有用
net.ipv4.ip_local_port_range=3000	60999  #default 32768	60999,这里为Tab而不是空格
net.ipv4.tcp_max_syn_backlog = 262144 #default 128, 记录的那些尚未收到客户端确认信息的连接请求的最大值,tcp_syncookies设置以后会忽略tcp_max_syn_backlog
net.core.somaxconn = 262144        #default 128
net.ipv4.tcp_max_tw_buckets = 262144 #default 16384
net.ipv4.tcp_max_orphans = 262144  #default 16384
net.core.netdev_max_backlog = 262144 #default 1000
#tcp_max_syn_backlog 是指定所能接受SYN同步包的最大客户端数量，即半连接上限；
#somaxconn 是指服务端所能accept即处理数据的最大客户端数量，即完成连接上限。

.Nginx打开文件最大数
1)
  apt install nginx-extras

  
2)vim /etc/nginx/nginx.conf
 worker_rlimit_nofile 15360;  #每个workersk可以打开的最大文件数量  
  
3)
 确认系统内核允许最大文件打开数 
 [root@localhost:~]# sysctl -n -e fs.file-max
  149904

 [root@localhost:~]# sysctl -n -e fs.file-max
  300257 
  
4)
grep 'ulimit -SHn 500000' /etc/profile || sed -i '$ a ulimit -SHn 500000' /etc/profile
grep 'nofile 500000' /etc/security/limits.conf || sed -i  '/End/ i  *  -   nofile 500000' /etc/security/limits.conf
grep 'LimitNOFILE=500000' /lib/systemd/system/nginx.service || { sed -i '/\[Service\]/aLimitNOFILE=500000' /lib/systemd/system/nginx.service ; systemctl daemon-reload ; /etc/init.d/nginx restart; }
grep 'session required pam_limits.so' /etc/pam.d/common-session ||  sed -i '/end of pam-auth-update/ i session required pam_limits.so' /etc/pam.d/common-session
grep 'session    required   pam_limits.so' /etc/pam.d/su ||  echo  'session    required   pam_limits.so' >> /etc/pam.d/su
grep 'session required /lib/security/pam_limits.so' /etc/pam.d/login ||  echo  'session required /lib/security/pam_limits.so' >> /etc/pam.d/login 

.ufw
1)vim /etc/default/ufw
  IPV6=no

2)  
ufw allow from 134.159.113.192/26        
ufw allow from 103.38.147.50             
ufw allow from 210.66.177.65             
ufw allow from 210.244.17.225            
ufw allow from 210.14.7.224/27 
ufw allow 80/tcp
ufw allow 443/tcp 

.certbot 
 1)安装certbot
 Ubuntu16.04
 add-apt-repository ppa:certbot/certbot 
 apt-get update 
 apt-get install python-certbot-nginx

 Ubuntu17.10
 apt-get update 
 apt-get install python-certbot-nginx

 2)注释掉自动更新 
 /etc/systemd/system/timers.target.wants/certbot.timer
 /etc/cron.d/certbot
 
 3)给域名添加证书
 certbot --nginx -d a.com -d www.a.com -d m.a.com
 
 4)更新 
 certbot --nginx renew
 
.scripts
 backup.sh
 certbot_renew.sh
 clean_boot.sh
 FasterMirror.sh
 gi.sh
 service.sh
 tcp.sh
 getdomains.sh
 ddos
   ddos.sh
   ddos.sh monitor
   ddos.sh clean
   whitelist.ip.conf
 lua
   nginx_access.lua
   AntiDDOS.lua
   IpBlock.lua
   ipdb
   whitelist.ip.conf 
 poc_agents_create_1.0.15   
 
 
.监控
 /data/monitor/
    install.sh
    linuxcheck

- name: Set sshd_config Ciphers
  lineinfile:
      path: /etc/ssh/sshd_config
      backup: yes
      line: "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc"

- name: Restart sshd
  systemd:
      name: sshd
      state: reloaded

- name: Set timezone
  timezone:
      name: '{{ localtimezone }}'


    - vim
    - gcc
    - wget
    - unzip
    - make
    - telnet
    - lvm2
    - chrony
    - git
    - python
    - xfsprogs

 https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb


 [client]
default-character-set		= utf8
port            		= 3306
socket          		= /var/lib/mysql/mysql.sock

[mysqld]
#--- GLOBAL ---#
datadir				= /var/lib/mysql
basedir				= /usr
tmpdir				= /var/lib/mysql
character_set_server		= utf8
socket          		= /var/lib/mysql/mysql.sock
event_scheduler			= ON
lower_case_table_names		= 1
user 				= mysql
port            		= 3306
log-error			= /var/lib/mysql/mysql-err.log
slow_query_log_file		= /var/lib/mysql/slowsql.log
slow_query_log			= 1
long_query_time			= 5
default-storage-engine		= innodb
log_bin_trust_function_creators	= 1
open_files_limit		= 65536
table_open_cache		= 2000
default_password_lifetime       = 0

#--- REPL ---#
server-id			= 1
log-bin 			= mysql-bin
binlog_format			= row
log-bin-index			= /var/lib/mysql/mysql-bin.index
relay-log                       = relay-log
sync_binlog			= 1
expire_logs_days		= 3
slave-parallel-workers          = 2
gtid_mode                       = on
enforce_gtid_consistency	= on
log-slave-updates
slave-skip-errors		= all


#--- INNODB ---#
innodb_file_per_table		= 1
innodb_buffer_pool_size         = 4G
innodb_open_files		= 65536

#--- NETWORK ---#
max_allowed_packet		= 16777216
max-connections                 = 2000
skip-name-resolve

[mysql]
prompt = 'MySQL \u@[\d]>'