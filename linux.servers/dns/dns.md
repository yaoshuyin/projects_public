**install**
```console
$ yum -y install bind bind-utils
```

**config**
```console
./etc/named.conf
options {
	listen-on port 53 { any; };
	listen-on-v6 port 53 { ::1; };
	directory 	       "/var/named";  #默认zones的目录
	dump-file 	       "/var/named/data/cache_dump.db";
	statistics-file    "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	recursing-file     "/var/named/data/named.recursing";
	secroots-file      "/var/named/data/named.secroots";
	allow-query        { any; };
  forwarders         {8.8.8.8; 8.8.4.4;};

	recursion yes;

	dnssec-enable yes;
	dnssec-validation yes;

	bindkeys-file "/etc/named.root.key";

	managed-keys-directory "/var/named/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

zone "x.com" IN {
   type master;
   file "zones/x.com.zone"; # /var/named/zones/x.com.zone
   allow-update {none;};
};

./var/named/zones/x.com.zone
$TTL 3600 ;域名在缓存服务器上存的秒数，超过3600秒则需去获取此域名的信息
;@           表示本域名
;SOA         描述授权域
;ns1.x.com.  域名x.com的域名解析请求将到ns1.x.com域查找
;root        表示接收信息的邮箱，此处为本地的root用户
@ IN SOA ns1.x.com. root (
   2015 ; serial 此域文件的版本号,资料有修改则需要改变此值
        ; 从服务器请求时发现此值与缓存中的SOA序列号不同时，则重新获取域名信息
   1D   ; refresh 指从域名服务器将每多少秒检查主服务器上信息
   1H   ; retry 从服务器查询失败后，过多久再次访问主服务器
   1W   ; expire 如从服务器超过此时间还不能访问主服务器，则删除此域名
   3H   ; minimum 如果没有明确指定TTL值,则使用此值做默认的缓存周期
)
       NS ns1         ;必须有NS字段，否则named无法启动
       A  172.18.0.1  ; @ A 172.18.0.1
ns1    A  172.18.0.8
test   A  172.18.0.1
bbs    A  172.18.0.1

$ chgrp named -R /var/named/zones
$ systemctl enable named
$ systemctl start named  ;

$ dig  @172.18.0.8 test.x.com
test.x.com.		3600	IN	A	172.18.0.1

$ dig  @172.18.0.8 ns1.x.com
ns1.x.com.		3600	IN	A	172.18.0.8

$ dig  @172.18.0.8 x.com
x.com.			3600	IN	A	172.18.0.1

```
![avatar](pic/test.png)
