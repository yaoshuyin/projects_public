***.install***
```bash
$ yum install php php-fpm
  yum install ntpdate epel-release vim curl wget 
  yum install php72w php72w-mysqlnd php72w-gd php72w-mbstring php72w-mcrypt php72w-devel php72w-xml 
  yum install rsyslog rsyslog-mysql -y

.install mysql 略
```

***导入sql***
```mysql
 $ mysql
 > create database syslog;
 > use syslog
 > source /usr/share/doc/rsyslog-8.24.0/mysql-createDB.sql;
 > alter table systemevents add `today` DATE;
 > alter table systemevents add unique key unimsg(fromhost,today,message(80));
``` 

***rsyslog***
```
.vim /etc/rsyslog.conf

$ModLoad imuxsock
$ModLoad imjournal
$ModLoad imudp
$UDPServerRun 514
$ModLoad imtcp
$InputTCPServerRun 514

$WorkDirectory /var/lib/rsyslog
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
$IncludeConfig /etc/rsyslog.d/*.conf
$OmitLocalLogging on
$IMJournalStateFile imjournal.state
*.info;mail.none;authpriv.none;cron.none                /var/log/messages
authpriv.*                                              /var/log/secure
mail.*                                                  -/var/log/maillog
cron.*                                                  /var/log/cron
*.emerg                                                 :omusrmsg:*
uucp,news.crit                                          /var/log/spooler
local7.*                                                /var/log/boot.log

$AllowedSender tcp, 192.168.0.0/16
$AllowedSender tcp, 172.0.0.0/8
$AllowedSender tcp, 10.133.0.0/16
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

if ( $msg contains "SELinux is preventing" or \
     $msg contains "unimsg" or \
     $msg contains "UFW BLOCK" or \
     $msg contains "refused connect from ::1" or \
     $msg contains "kex_exchange_identification" or \
     $msg contains "system_bus_socket" or \
     $msg contains "message repeated" or \
     $msg contains "took too long" \
     $msg contains "CCafException" \
) then {
     stop
}

$RepeatedMsgReduction on

$ModLoad ommysql
$template insertpl,"insert into SystemEvents (Message, Facility, FromHost, Priority, DeviceReportedTime, ReceivedAt, InfoUnitID, SysLogTag,today) values ('%msg%', %syslogfacility%, '%HOSTNAME%:%fromhost-ip%', %syslogpriority%, '%timereported:::date-mysql%', '%timegenerated:::date-mysql%', %iut%, '%syslogtag%',DATE(CURRENT_TIMESTAMP))",SQL
*.warning,*.alert,*.crit,*.emerg,*.err,*.error :ommysql:localhost,syslog,syslog,Syslog34aa8#fe;insertpl

& ~
```

***重启rsyslog***
```bash
$ systemctl restart rsyslog
```

***LogAnalyzer***
```
$ vim /etc/nginx/nginx.conf
   server {
        listen       80 default_server;
        server_name  _;

         allow 127.0.0.1;
         allow 10.133.100.10;
         deny all;

        location / {
           root         /data/www/htdocs/loganalyzer;
        }
        
        location ~ \.php$ {
           root         /data/www/htdocs/loganalyzer;
           fastcgi_pass   127.0.0.1:9000;
           fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
           include        fastcgi_params;
        }
  }

$ cd /data/www/htdocs/loganalyzer
$ wget --no-check-certificate  -c https://download.adiscon.com/loganalyzer/loganalyzer-4.1.12.tar.gz
$ tar xvf loganalyzer-4.1.12.tar.gz
$ mv loganalyzer-4.1.12/src ./
```

***web 安装***
```bash
1)浏览器
http://127.0.0.1/install.php

2)修改config.php
$CFG['ViewEnableAutoReloadSeconds'] = 30;
$CFG['ViewEntriesPerPage'] = 12; 

```
