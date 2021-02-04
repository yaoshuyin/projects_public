.**系统初始化**
```
..............................................
1)配置host
a)vim /etc/hosts
192.168.0.30 mha-manager
192.168.0.32 mha-mysql-master
192.168.0.33 mha-mysql-slave01 (for master backup)
192.168.0.34 mha-mysql-slave02

b)设置host
hostnamectl set-hostname mha-manager
...

2)系统更新
yum update
yum install -y yum-utils

3)安装ntp
yum install -y ntp
systemctl enable ntpd
systemctl start ntpd

4)防火墙开放3306端口
firewall-cmd --permanent --new-zone=mysql
firewall-cmd --permanent --zone=mysql --add-source=192.168.0.0/24
firewall-cmd --permanent --zone=mysql --add-port=3306/tcp
firewall-cmd --reload

firewall-cmd --list-all-zone 
firewall-cmd --list-all


.安装mysql （所有mysql服务器 mha-mysql-master mha-mysql-slave01 mha-mysql-slave02)
......................................................
1)安装mysql repo

rpm -i  https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
yum update

yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum update

yum install mysql-community-server

systemctl enable mysqld

2)mysql conf
a)master 
[client]
default-character-set=utf8

[mysqld]
character_set_server=utf8
# innodb_buffer_pool_size = 128M
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

skip-name-resolve

symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
server-id=1
log-bin=mysql-bin
relay_log_purge=0
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

binlog_group_commit_sync_no_delay_count=100
binlog_group_commit_sync_delay=1000

slave_parallel_type='LOGICAL_CLOCK'
relay_log_info_repository='TABLE'
master_info_repository='TABLE'
slave_parallel_workers=8
relay_log_recovery=1

slave-skip-errors = 1133

#replicate-ignore-db = mysql
#replicate-ignore-db = information_schema
#replicate-ignore-db = performance_schema
#replicate_wild_ignore_table=mysql.%
#replicate_wild_ignore_table=information_schema.%
#replicate_wild_ignore_table=performance_schema.%


b)slave01
[client]
default-character-set=utf8

[mysqld]
character_set_server=utf8
# innodb_buffer_pool_size = 128M
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
server-id=2
log-bin=mysql-bin
relay_log_purge=0
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

binlog_group_commit_sync_no_delay_count=100
binlog_group_commit_sync_delay=1000

skip-name-resolve
slave_parallel_type='LOGICAL_CLOCK'
relay_log_info_repository='TABLE'
master_info_repository='TABLE'
slave_parallel_workers=8
relay_log_recovery=1

read_only = ON

slave-skip-errors = 1133

#replicate-ignore-db = mysql
#replicate-ignore-db = information_schema
#replicate-ignore-db = performance_schema
#replicate_wild_ignore_table=mysql.%
#replicate_wild_ignore_table=information_schema.%
#replicate_wild_ignore_table=performance_schema.%


b)slave02
[client]
default-character-set=utf8

[mysqld]
character_set_server=utf8
# innodb_buffer_pool_size = 128M
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
server-id=3
log-bin=mysql-bin
relay_log_purge=0
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

binlog_group_commit_sync_no_delay_count=100
binlog_group_commit_sync_delay=1000


skip-name-resolve
slave_parallel_type='LOGICAL_CLOCK'
relay_log_info_repository='TABLE'
master_info_repository='TABLE'
slave_parallel_workers=8
relay_log_recovery=1
read_only = ON

slave-skip-errors = 1133

#replicate-ignore-db = mysql
#replicate-ignore-db = information_schema
#replicate-ignore-db = performance_schema
#replicate_wild_ignore_table=mysql.%
#replicate_wild_ignore_table=information_schema.%
#replicate_wild_ignore_table=performance_schema.%

3)start mysql
systemctl start mysqld

4)设置密码
$ grep 'temporary password' /var/log/mysqld.log
     temporary password is generated for root@localhost: nbwIjF3zC

MySQL>  alter user 'root'@'localhost' identified by 'Aa123456!';

MySQL>  grant all privileges on *.* to 'root'@'192.168.0.%' identified by 'Aa123456!' with grant option;
MySQL>  FLUSH PRIVILEGES; 

#设置mhamanager连接数据库的账号、密码、权限
MySQL> grant all on *.* to 'mhamng'@'192.168.0.%' identified by 'Aa123456!';

#设置slave复制账号、密码、权限
MySQL> grant replication slave,REPLICATION CLIENT on *.* to 'rep'@'192.168.0.%' identified by 'Aa123456!';  

#启用半同步 
MySQL> install plugin rpl_semi_sync_master soname 'semisync_master.so';
MySQL> set global rpl_semi_sync_master_enabled=1;

#设置超时时间(毫秒)
set global rpl_semi_sync_master_timeout=1000;

#mha-mysql-slave01 mha-mysql-slave02 change master
MySQL> stop slave;
MySQL> change master to master_host='192.168.0.32', master_user='rep', master_password='Aa123456!', master_port=3306, MASTER_AUTO_POSITION = 1, MASTER_RETRY_COUNT = 0, MASTER_HEARTBEAT_PERIOD = 100000;
MySQL> start slave;
MySQL> show slave status \G; 


................................................

.MHA安装
.........................

1)所有服务器
$ yum install -y perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch perl-Parallel-ForkManager perl-YAML-Tiny perl-PAR-Dist perl-Module-ScanDeps perl-Module-CoreList perl-Module-Build perl-CPAN perl-CPANPLUS perl-File-Remove perl-Module-Install

下载mha4mysql-manager mha4mysql-node
https://github.com/yoshinorim/mha4mysql-manager
https://github.com/yoshinorim/mha4mysql-node

$ rpm -i mha4mysql-manager-0.58-0.el7.centos.noarch.rpm mha4mysql-node-0.58-0.el7.centos.noarch.rpm

$ mkdir -p /var/log/mha/app1
$ touch /var/log/mha/app1/manager.log
$ mkdir /etc/mha
$ vim /etc/mha/app1_master_ip_failover
#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use Getopt::Long;
use MHA::DBHelper;

my (
  $command,        $ssh_user,         $orig_master_host,
  $orig_master_ip, $orig_master_port, $new_master_host,
  $new_master_ip,  $new_master_port,  $new_master_user,
  $new_master_password
);
my $eth = "enp0s3";
my $vip = '192.168.0.29/24';
my $key = "1";
my $ssh_start_vip = "/sbin/ifconfig $eth:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig $eth:$key down";

GetOptions(
  'command=s'             => \$command,
  'ssh_user=s'            => \$ssh_user,
  'orig_master_host=s'    => \$orig_master_host,
  'orig_master_ip=s'      => \$orig_master_ip,
  'orig_master_port=i'    => \$orig_master_port,
  'new_master_host=s'     => \$new_master_host,
  'new_master_ip=s'       => \$new_master_ip,
  'new_master_port=i'     => \$new_master_port,
  'new_master_user=s'     => \$new_master_user,
  'new_master_password=s' => \$new_master_password,
);

exit &main();

sub main {
  if ( $command eq "stop" || $command eq "stopssh" ) {

    # $orig_master_host, $orig_master_ip, $orig_master_port are passed.
    # If you manage master ip address at global catalog database,
    # invalidate orig_master_ip here.
    my $exit_code = 1;
    eval {

      # updating global catalog, etc
      $exit_code = 0;
    };
    if ($@) {
      warn "Got Error: $@\n";
      exit $exit_code;
    }
    exit $exit_code;
  }
    elsif ( $command eq "start" ) {

        # all arguments are passed.
        # If you manage master ip address at global catalog database,
        # activate new_master_ip here.
        # You can also grant write access (create user, set read_only=0, etc) here.
        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        `ssh $ssh_user\@$orig_master_host \" $ssh_start_vip \"`;
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}


sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
# A simple system call that disable the VIP on the old_master 
sub stop_vip() {
   `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}


sub usage {
  print
"Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}

$ vim /etc/mha/app1.cnf
[server default]
manager_log=/var/log/mha/app1/manager.log
manager_workdir=/var/log/mha/app1
master_binlog_dir=/var/lib/mysql
master_ip_failover_script=/etc/mha/app1_master_ip_failover
password="Aa123456!"
ping_interval=1
repl_password="Aa123456!"
repl_user=rep
secondary_check_script=masterha_secondary_check -s 192.168.0.32 -s 192.168.0.33 -s 192.168.0.34
ssh_user=root
user=mhamng

[server1]
candidate_master=1
check_repl_delay=0
hostname=192.168.0.32
master_binlog_dir="/var/lib/mysql"

[server2]
candidate_master=1
check_repl_delay=0
hostname=192.168.0.33
master_binlog_dir="/var/lib/mysql"

[server3]
candidate_master=0
check_repl_delay=0
hostname=192.168.0.34
master_binlog_dir="/var/lib/mysql"
no_master=1 

$ masterha_check_ssh --conf=/etc/mha/app1.cnf
$ masterha_check_repl --conf=/etc/mha/app1.cnf 

$ nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

$ masterha_check_status --conf=/etc/mha/app1.cnf 

....................................................................

停止master，测试master与vip的切换
192.168.0.32$ systemctl stop mysqld
$ cat /var/log/mha/app1/manager.log
  ......
  ...... master 192.168.0.33 .....
192.168.0.32$ ip addr
  ...... 192.168.0.29 ....
```
