**install**
```console
```

**config**
```console
#1)forward IP: 192.168.0.100
zone "." IN {
    type hint;
    file "named.ca";
};

options {
    ...
    forwarders {8.8.8.8; 8.8.4.4;};
};

2)client
vim /etc/resolv.conf
nameserver 192.168.0.100

3)test
dig baidu.com
```
![F%i](pic/test.png)
